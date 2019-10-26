set :application_variable, "RAILS_APP"
set :output, "#{Whenever.path}/log/cron.log"

Setting.load(env: @environment, app: @application)

deployer = Dir.pwd.match(/home\/(\w+)\//)[1]
rbenv_ruby = %{export PATH="/home/#{deployer}/.rbenv/bin:/home/#{deployer}/.rbenv/plugins/ruby-build/bin:$PATH"; eval "$(rbenv init -)"}
context = %{export RAKE_OUTPUT=true; #{rbenv_ruby}; cd :path && :environment_variable=:environment :application_variable=:application}
flock = %{flock -n #{Whenever.path}/tmp/locks/:task.lock}
rake = File.file?("#{Whenever.path}/bin/rake") ? 'bin/rake' : ':bundle_command rake'

job_type :rake, "#{context} #{flock} nice -n 19 #{rake} :task --silent :output"
job_type :bash, "#{context} #{flock} bash -e -u bin/:task :output"
