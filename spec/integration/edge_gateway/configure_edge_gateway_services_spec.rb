require 'spec_helper'

module Vcloud
  module Core
    describe EdgeGateway do

      required_env = {
        'VCLOUD_EDGE_GATEWAY' => 'to name of VSE',
      }

      error = false
      required_env.each do |var,message|
        unless ENV[var]
          puts "Must set #{var} #{message}" unless ENV[var]
          error = true
        end
      end
      Kernel.exit(2) if error

      it "updates the edge gateway" do
        configuration = {
            :FirewallService =>
                {
                    :IsEnabled        => "true",
                    :FirewallRule     => [],
                    :DefaultAction    => "drop",
                    :LogDefaultAction => "false",
                },
            :LoadBalancerService =>
                {
                    :IsEnabled      => "true",
                    :Pool           => [],
                    :VirtualServer  => [],
                },
            :NatService =>
                {
                    :IsEnabled  => "true",
                    :NatRule    => [],
                },
        }

        edge_gateway = EdgeGateway.get_by_name(ENV['VCLOUD_EDGE_GATEWAY'])
        edge_gateway.update_configuration(configuration)

        actual_config = edge_gateway.vcloud_attributes[:Configuration][:EdgeGatewayServiceConfiguration]
        actual_config[:FirewallService].should == configuration[:FirewallService]
        actual_config[:LoadBalancerService].should == configuration[:LoadBalancerService]
        actual_config[:NatService].should == configuration[:NatService]
      end
    end
  end
end