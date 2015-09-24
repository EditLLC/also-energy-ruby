require './test/test_helper'

describe AlsoEnergy::Client do

  soap_url = "https://www.alsoenergy.com/WebAPI/WebAPI.svc"
  wsdl_url = "http://www.alsoenergy.com/WebAPI/WebAPI.svc?wsdl"

  describe "initialization" do

    describe "#username" do
      it "accepts a client username" do
        @client = AlsoEnergy::Client.new do |c|
          c.username = "thedoge"
        end
        assert_equal "thedoge", @client.username
      end
    end

    describe "#password" do
      it "accepts a client password" do
        @client = AlsoEnergy::Client.new do |c|
          c.password = "12345"
        end
        assert_equal "12345", @client.password
      end
    end

    describe "#session_id" do
      it "accepts an auth session id" do
        @client = AlsoEnergy::Client.new do |c|
          c.session_id = "totallynotnil"
        end
        assert_equal "totallynotnil", @client.session_id
      end
    end

  end

  describe "the authentication process" do

    describe "#login" do

      before do
        wsdl_query_fixture = YAML.load_file("test/fixtures/also_energy_wsdl_query.yml")
        stub_request(:get, wsdl_url).to_return(:body => wsdl_query_fixture["body"]["string"])
        @client = AlsoEnergy::Client.new do |c|
          c.username = "SpaceDoge"
          c.password = "12345"
          c.session_id = nil
        end
      end

      it "raises an exception for login failure" do

        fixture = YAML.load_file("test/fixtures/also_energy_invalid_login.yml")
        stub_request(:post, soap_url).with(:body => fixture["request"]["body"]["string"]
          ).to_return(:body => fixture["response"]["body"]["string"])

        assert_raises(AlsoEnergy::AuthError) do
          @client.login
        end

      end

      it "assigns a session_id after successful authentication" do

        fixture = YAML.load_file("test/fixtures/also_energy_successful_login.yml")
        stub_request(:post, soap_url).with(:body => fixture["request"]["body"]["string"]
          ).to_return(:body => fixture["response"]["body"]["string"])

        @client.login
        @client.session_id.must_equal "SESSION_ID"

      end

    end

  end

  describe "the client data query process" do

    before do
      wsdl_query_fixture = YAML.load_file("test/fixtures/also_energy_wsdl_query.yml")
      stub_request(:get, wsdl_url).to_return(:body => wsdl_query_fixture["body"]["string"])
      @client = AlsoEnergy::Client.new do |c|
        c.username = "SpaceDoge"
        c.password = "12345"
        c.session_id = "SESSION_ID"
      end
    end

    describe "#get_sites" do
      it "successfully returns an array of AlsoEnergy::Site objects from the API" do

        fixture = YAML.load_file("test/fixtures/also_energy_get_sites_query_success.yml")
        stub_request(:post, soap_url).with(:body => fixture["request"]["body"]["string"]
          ).to_return(:body => fixture["response"]["body"]["string"])

        @client.get_sites.wont_be_nil

      end

      it "raises an AlsoEnergy::QueryError if get_sites is not successful" do

        fixture = YAML.load_file("test/fixtures/also_energy_get_sites_query_failure.yml")
        stub_request(:post, soap_url).with(:body => fixture["request"]["body"]["string"]
          ).to_return(:body => fixture["response"]["body"]["string"])

        assert_raises(AlsoEnergy::QueryError) do
          @client.get_sites
        end

      end

    end

  end

end
