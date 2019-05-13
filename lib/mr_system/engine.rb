module MrSystem
  class Engine < ::Rails::Engine
    # require 'ext_capistrano'
    # require 'ext_minitest'
    require 'ext_rake'
    require 'ext_ruby'
    require 'ext_sql'
    # require 'ext_whenever'
    require 'mr_backup'
    require 'mr_notifier'
    require 'mr_recipe'
    require 'mr_secret'
    # require 'sun_cap'
    # require 'sunzistrano'
  end
end
