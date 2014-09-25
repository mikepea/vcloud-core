require 'spec_helper'

RSpec.configure do |config|
  config.before(:each) do
    Vcloud::Core::Fog::Connection.instance_variable_set :@default_connection, nil
  end
end

describe Vcloud::Core::Fog::Connection do

  let(:mock_fog_conn) { double(:mock_fog_conn) }
  let(:mock_fog_conn_2) { double(:mock_fog_conn_2) }

  describe ".default_connection" do

    it "returns an initial connection" do
      expect(::Fog::Compute::VcloudDirector).to receive(:new).exactly(1).times.and_return(mock_fog_conn)
      expect(Vcloud::Core::Fog::Connection.default_connection).to be(mock_fog_conn)
    end

    it "returns the same connection object when called multiple times" do
      expect(::Fog::Compute::VcloudDirector).to receive(:new).exactly(1).times.and_return(mock_fog_conn)
      expect(Vcloud::Core::Fog::Connection.default_connection).to be(mock_fog_conn)
      expect(Vcloud::Core::Fog::Connection.default_connection).to be(mock_fog_conn)
    end

  end

  describe ".set_default_connection" do

    it "updates the default connection stored in the class" do
      expect(::Fog::Compute::VcloudDirector).to receive(:new).exactly(1).times.and_return(mock_fog_conn)
      expect(Vcloud::Core::Fog::Connection.default_connection).to be(mock_fog_conn)
      Vcloud::Core::Fog::Connection.set_default_connection(mock_fog_conn_2)
      expect(Vcloud::Core::Fog::Connection.default_connection).to be(mock_fog_conn_2)
    end

    it "can be run before default_connection is called" do
      expect(::Fog::Compute::VcloudDirector).not_to receive(:new)
      Vcloud::Core::Fog::Connection.set_default_connection(mock_fog_conn_2)
      expect(Vcloud::Core::Fog::Connection.default_connection).to be(mock_fog_conn_2)
    end

  end

end
