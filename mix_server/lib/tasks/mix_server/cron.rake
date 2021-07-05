namespace :cron do
  desc 'every day cron jobs'
  task :every_day, [:dump, :cluster] => :environment do |t, args|
    if flag_on? args, :cluster
      run_task 'check:cleanup'                 if defined? MixCheck
      run_task 'global:cleanup'
      run_task 'list:reorganize'
    else
      run_task 'check:cleanup'                 if defined? MixCheck
      run_task 'credential:lets_encrypt:renew' if defined? MixCertificate
      run_task 'flash:cleanup'                 if defined? MixFlash
      run_task 'geo:import_ips'                if defined? MixGeo
      run_task 'global:cleanup'
      run_task 'list:reorganize'
      run_task 'log:cleanup'
      run_task 'log:extract'
      run_task 'log:rollup'
      run_task 'log:report'
      if flag_on? args, :dump
        run_task 'db:pg:dump',
          base_dir: ExtRails.config.backup_dir,
          split: true,
          md5: true,
          rotate: true,
          excludes: ExtRails.config.backup_excludes.to_a.join(','),
          migrations: false
      end
    end
  end

  desc 'every 5 minutes cron jobs'
  task :every_5_minutes => :environment do
    run_task 'check:capture' if defined? MixCheck
  end
end
