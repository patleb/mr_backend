namespace :mr_setting do
  desc 'setup secrets.yml, settings.yml, initializers/mr_setting.rb, database.yml and .gitignore files'
  task :setup, [:no_master_key, :force] => :environment do |t, args|
    src, dst = MrSetting.root.join('lib/tasks/templates'), Rails.root

    ['config/initializers/mr_setting.rb', 'config/settings.yml'].each do |file|
      cp src.join(file), dst.join(file)
    end

    ['config/secrets.yml', 'config/secrets.example.yml'].each do |file|
      secret = dst.join(file)
      if flag_on?(args, :force) || !secret.exist?
        write secret, ERB.template(src.join('config/secrets.yml.erb'), binding)
      end
    end

    write dst.join('config/database.yml'), ERB.template(src.join('config/database.yml.erb'), binding)

    gitignore dst, '/config/secrets.yml'

    if flag_on? args, :no_master_key
      ['config/credentials.yml.enc', 'config/master.key', 'tmp/development_secret.txt'].each do |file|
        remove dst.join(file) rescue nil
      end
    end
  end
end

namespace :setting do
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
  end
end