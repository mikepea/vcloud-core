require 'spec_helper'

module Vcloud
  module Fog
    describe ServiceInterface do

      FOG_SESSION_RESPONSE = {:xmlns => 'http://www.vmware.com/vcloud/v5.1', :xmlns_xsi => 'http://www.w3.org/2001/XMLSchema-instance', :user => 'me@dexample.com', :org => 'my_org', :type => 'application/vnd.vmware.vcloud.session+xml', :href => 'https://example.org/api/session/', :xsi_schemaLocation => 'http://www.vmware.com/vcloud/v5.1 http://example.org/api/v5.1/schema/master.xsd', :Link => [{:rel => 'down', :type => 'application/vnd.vmware.vcloud.orgList+xml', :href => 'https://example.com/api/org/'}, {:rel => 'down', :type => 'application/vnd.vmware.admin.vcloud+xml', :href => 'https://example.com/api/admin/'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.org+xml', :name => 'vdc_name', :href => 'https://example.com/api/org/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.query.queryList+xml', :href => 'https://example.com/api/query'}, {:rel => 'entityResolver', :type => 'application/vnd.vmware.vcloud.entity+xml', :href => 'https://example.com/api/entity/'}, {:rel => 'down:extensibility', :type => 'application/vnd.vmware.vcloud.apiextensibility+xml', :href => 'https://example.com/api/extensibility'}]}
      FOG_ORGANIZATION_RESPONSE = {:xmlns => 'http://www.vmware.com/vcloud/v5.1', :xmlns_xsi => 'http://www.w3.org/2001/XMLSchema-instance', :name => 'org_name', :id => 'urn:vcloud:org:0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0', :type => 'application/vnd.vmware.vcloud.org+xml', :href => 'https://example.com/api/org/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0', :xsi_schemaLocation => 'http://www.vmware.com/vcloud/v1.5 http://example.com/api/v1.5/schema/master.xsd', :Link => [{:rel => 'down', :type => 'application/vnd.vmware.vcloud.vdc+xml', :name => 'vdc_name', :href => 'https://example.com/api/vdc/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.tasksList+xml', :href => 'https://example.com/api/tasksList/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.catalog+xml', :name => 'Appliances', :href => 'https://example.com/api/catalog/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.controlAccess+xml', :href => 'https://example.com/api/org/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0X/catalog/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0/controlAccess/'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.catalog+xml', :name => 'Public Catalog', :href => 'https://example.com/api/catalog/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.controlAccess+xml', :href => 'https://example.com/api/org/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0/catalog/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0/controlAccess/'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.catalog+xml', :name => 'walker-ci', :href => 'https://example.com/api/catalog/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.controlAccess+xml', :href => 'https://example.com/api/org/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0/catalog/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0/controlAccess/'}, {:rel => 'controlAccess', :type => 'application/vnd.vmware.vcloud.controlAccess+xml', :href => 'https://example.com/api/org/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0/catalog/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0/action/controlAccess'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.catalog+xml', :name => 'Images', :href => 'https://example.com/api/catalog/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.controlAccess+xml', :href => 'https://example.com/api/org/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0/catalog/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0/controlAccess/'}, {:rel => 'add', :type => 'application/vnd.vmware.admin.catalog+xml', :href => 'https://example.com/api/admin/org/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0/catalogs'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.orgNetwork+xml', :name => 'walker-ci-network', :href => 'https://example.com/api/network/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.orgNetwork+xml', :name => 'backend', :href => 'https://example.com/api/network/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.supportedSystemsInfo+xml', :href => 'https://example.com/api/supportedSystemsInfo/'}, {:rel => 'down', :type => 'application/vnd.vmware.vcloud.metadata+xml', :href => 'https://example.com/api/org/0a0a0a0-0a0a0-0a0a-0a0a-0a0a0a0a0a0/metadata'}], :Description => 'Added description', :FullName => 'GDS CI Tools', :Tasks => {:Task => []}}

      it 'should raise a exception if named vdc not found in the data returned' do

        fog_facade = double(:FogFacade)
        expect(fog_facade).to receive(:session) { FOG_SESSION_RESPONSE }
        expect(fog_facade).to receive(:get_organization) { FOG_ORGANIZATION_RESPONSE }

        service_interface = ServiceInterface.new(fog_facade)

        expect { service_interface.vdc('DoesNotExist') }.to raise_exception(RuntimeError, 'vdc DoesNotExist cannot be found')
      end

      context 'configure edge gateway' do
        before(:each) do
          @config = { :Blah => 'TestData' }
          @vcloud = double(:vcloud)
          expect(::Vcloud::Core).to receive(:connection).and_return(@vcloud)
        end

        it "should configure firewall for given edge gateway id" do
          task = double(:task)
          expect(Vcloud::Core::logger).to receive(:info).with("Updating EdgeGateway 1234")
          expect(@vcloud).to receive(:post_configure_edge_gateway_services).with("1234", @config).
              and_return(double(:response, :body =>  task ))
          expect(@vcloud).to receive(:process_task).with(task)

          ServiceInterface.new.post_configure_edge_gateway_services "1234", @config
        end


        it "should log and return exceptions without swallowing" do
          expect(Vcloud::Core::logger).to receive(:info).with("Updating EdgeGateway 1234")
          runtime_error = RuntimeError.new('Test Error')
          expect(Vcloud::Core::logger).to receive(:error).with("Could not update EdgeGateway 1234 : #{runtime_error}")
          expect(@vcloud).to receive(:post_configure_edge_gateway_services).with("1234", @config).
              and_raise(runtime_error)
          expect{ ServiceInterface.new.post_configure_edge_gateway_services("1234", @config) }.to raise_error("Test Error")
        end
      end

    end
  end
end
