require './test/test_helper'

describe AlsoEnergy::Client do

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
        VCR.insert_cassette "also_energy_invalid_login"
      end
      it "raises an exception for login failure" do
        @client = AlsoEnergy::Client.new do |c|
          c.username = "thedoge"
          c.password = "12345"
          c.session_id = "totallynotnil"
        end
        assert_raises(AlsoEnergy::AuthError) do
          @client.login
        end
      end
    end
  end

end
