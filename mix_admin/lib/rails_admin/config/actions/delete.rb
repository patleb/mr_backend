class RailsAdmin::Config::Actions::Delete < RailsAdmin::Config::Actions::Base
  register_instance_option :link_weight, memoize: true do
    100
  end

  register_instance_option :link_icon, memoize: true do
    'fa fa-trash-o fa-fw'
  end

  def member?
    true
  end

  def http_methods
    [:get, :put, :delete]
  end
end
