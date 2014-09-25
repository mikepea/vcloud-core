require 'fog'

module Vcloud
  module Core
    module Fog
      class Connection

        def self.set_default_connection(conn)
          @default_connection = conn
        end

        def self.default_connection
          @default_connection ||= ::Fog::Compute::VcloudDirector.new()
        end

      end
    end
  end
end
