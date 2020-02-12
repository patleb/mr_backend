namespace :mix_setting do
  desc 'setup MixSetting files'
  task :setup, [:no_master_key, :force] => :environment do |t, args|
    src, dst = MixSetting.root.join('lib/tasks/templates'), Rails.root

    ['config/setting.rb', 'config/settings.yml'].each do |file|
      cp src/file, dst/file
    end
    ['config/secrets.yml', 'config/secrets.example.yml'].each do |file|
      secret = dst/file
      if flag_on?(args, :force) || !secret.exist?
        write secret, template(src/'config/secrets.yml.erb')
      end
    end
    write     dst/'config/database.yml', template(src/'config/database.yml.erb')
    gitignore dst, '/config/secrets.yml'

    if flag_on? args, :no_master_key
      ['config/credentials.yml.enc', 'config/master.key', 'tmp/development_secret.txt'].each do |file|
        remove dst/file rescue nil
      end
    end
  end
end

# TODO rotate :secret_key_base
namespace :setting do
  task :context => :environment do
    puts "{ env: #{Setting.rails_env}, app: #{Setting.rails_app} }"
  end

  task :dump, [:env, :app, :file] do |t, args|
    raise 'argument [:app] must be specified' unless (ENV['RAILS_APP'] = args[:app]).present?
    raise 'argument [:file] must be specified' unless (file = args[:file]).present?
    assign_environment! args

    Pathname.new(file).expand_path.write(Setting.to_yaml)
    puts "[#{ENV['RAILS_APP']}_#{ENV['RAILS_ENV']}] settings written to file [#{file}]"
  end

  desc "encrypt file or ENV['DATA']"
  task :encrypt, [:env, :file] do |t, args|
    assign_environment! args

    if ENV['DATA'].present?
      puts Setting.encrypt(ENV['DATA'])
    else
      puts Setting.encrypt(Pathname.new(args[:file]).expand_path.read)
    end
  end

  desc "decrypt key and optionally output to file"
  task :decrypt, [:env, :key, :file] do |t, args|
    assign_environment! args

    Setting.load
    if args[:file].present?
      Pathname.new(args[:file]).expand_path.write(Setting[args[:key]])
      puts "[#{args[:key]}] key written to file [#{args[:file]}]"
    else
      value =
        if ENV['DATA'].present?
          Setting.decrypt(ENV['DATA'])
        else
          Setting[args[:key]]
        end
      if ENV['ESCAPE'].to_b
        value = value.escape_newlines
      end
      if ENV['UNESCAPE'].to_b
        value = value.unescape_newlines
      end
      puts value
    end
  end

  desc 'escape file newlines'
  task :escape, [:file] do |t, args|
    puts Pathname.new(args[:file]).expand_path.read.escape_newlines
  end

  def assign_environment!(args)
    raise 'argument [:env] must be specified' unless (ENV['RAILS_ENV'] = args[:env]).present?
    ENV['RAILS_APP'] ||= ENV['APP']
    ENV['RAILS_ROOT'] ||= ENV['ROOT']
    # TODO Setting.reload if env, app or root changed and ensure with Setting.rollback!
  end
end