require './test/test_helper'

describe AlsoEnergy::Client do
  wsdl_query_fixture = YAML.load_file('test/fixtures/updated_wsdl.yml')

  def soap_request(fixture)
    stub_request(:post, 'https://www.alsoenergy.com/WebAPI/WebAPI.svc')
      .with(body: fixture['request']['body']['string'])
      .to_return(body: fixture['response']['body']['string'])
  end

  def wsdl_query(wsdl_query_fixture)
    stub_request(:get, 'http://www.alsoenergy.com/WebAPI/WebAPI.svc?wsdl')
      .to_return(body: wsdl_query_fixture['body']['string'])
  end

  describe 'initialization' do
    describe '#username' do
      it 'accepts a client username' do
        @client = AlsoEnergy::Client.new do |c|
          c.username = 'thedoge'
        end
        assert_equal 'thedoge', @client.username
      end
    end

    describe '#password' do
      it 'accepts a client password' do
        @client = AlsoEnergy::Client.new do |c|
          c.password = '12345'
        end
        assert_equal '12345', @client.password
      end
    end

    describe '#session_id' do
      it 'accepts an auth session id' do
        @client = AlsoEnergy::Client.new do |c|
          c.session_id = 'totallynotnil'
        end
        assert_equal 'totallynotnil', @client.session_id
      end
    end
  end

  describe 'the authentication process' do
    describe '#login' do
      before do
        wsdl_query(wsdl_query_fixture)
        @client = AlsoEnergy::Client.new do |c|
          c.username = 'SpaceDoge'
          c.password = '12345'
          c.session_id = nil
        end
      end

      it 'assigns a session_id after successful authentication' do
        fixture = YAML.load_file('test/fixtures/also_energy_successful_login.yml')
        soap_request(fixture)

        @client.login
        @client.session_id.must_equal 'SESSION_ID'
      end

      it 'raises an exception for login failure' do
        fixture = YAML.load_file('test/fixtures/also_energy_invalid_login.yml')
        soap_request(fixture)

        assert_raises(AlsoEnergy::AuthError) do
          @client.login
        end
      end
    end
  end

  describe 'the client data query process' do
    before do
      wsdl_query(wsdl_query_fixture)
      @client = AlsoEnergy::Client.new do |c|
        c.session_id = 'SESSION_ID'
      end
    end

    describe '#get_sites' do
      it 'successfully returns an array of AlsoEnergy::Site objects' do
        fixture = YAML.load_file('test/fixtures/also_energy_get_sites_query_success.yml')
        soap_request(fixture)

        @client.get_sites.wont_be_nil
      end

      it 'raises an AlsoEnergy::QueryError if get_sites is not successful' do
        fixture = YAML.load_file('test/fixtures/also_energy_get_sites_query_failure.yml')
        soap_request(fixture)

        assert_raises(AlsoEnergy::QueryError) do
          @client.get_sites
        end
      end
    end

    describe '#get_site_hardware' do
      it 'successfully returns an array of AlsoEnergy::HardWare objects' do
        fixture = YAML.load_file('test/fixtures/also_energy_get_site_hardware_success.yml')
        soap_request(fixture)

        @client.get_site_hardware('SITE_ID').wont_be_nil
      end

      it 'raises an AlsoEnergy::QueryError if get_site_hardware is not successful' do
        fixture = YAML.load_file('test/fixtures/also_energy_get_site_hardware_failure.yml')
        soap_request(fixture)

        assert_raises(AlsoEnergy::QueryError) do
          @client.get_site_hardware('SITE_ID')
        end
      end
    end
  end
end
