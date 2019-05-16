module MrSystem
  module Vpn
    module Connect
      extend ActiveSupport::Concern

      class_methods do
        def steps
          [:connect_vpn]
        end

        def vpn_client_name
          Secret[:vpn_client_name] || "client_#{ExtRake.config.rails_env}"
        end
      end

      def before_run
        @vpn_client_name = self.class.vpn_client_name
      end

      def connect_vpn
        sh "sudo systemctl start openvpn@#{@vpn_client_name}"

        sleep 5
      end

      def after_ensure(exception)
        sh "sudo systemctl stop openvpn@#{@vpn_client_name}"
      end
    end
  end
end