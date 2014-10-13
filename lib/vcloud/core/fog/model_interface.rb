module Vcloud
  module Core
    module Fog

      # Private interface to the fog model layer.
      # You should not use this directly. Expose required
      # functionality in {Vcloud::Core::ApiInterface}
      #
      # @api private
      class ModelInterface
        def initialize
          @vcloud = ::Vcloud::Core::Fog::Connection.default_connection
        end

        def org_name
          @vcloud.org_name
        end

        def current_organization
          @vcloud.organizations.get_by_name org_name
        end

        def current_vdc vdc_id
          current_organization.vdcs.detect { |v| v.id == vdc_id }
        end

        def get_vm_by_href href
          vm = @vcloud.get_vms_in_lease_from_query(
              {
                  :filter => "href==#{href}"
              }).body[:VMRecord].first
          return nil unless vm
          vdc = current_vdc(vm[:vdc].split('/').last)
          vapp = vdc.vapps.get_by_name(vm[:containerName])
          vapp.vms.first
        end

      end
    end
  end
end
