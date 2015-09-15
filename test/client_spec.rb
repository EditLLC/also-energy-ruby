require './test/test_helper'

describe AlsoEnergy::Client do

  describe "initialization" do

    describe "#username" do
      it "accepts a client username" do
        @client = AlsoEnergy::Client.new do |c|
          c.username = "thedoge"
        end
        @client.username.must_equal "thedoge"
      end
    end

    describe "#password" do
      it "accepts a client password" do
        @client = AlsoEnergy::Client.new do |c|
          c.password = "12345"
        end
        @client.password.must_equal "12345"
      end
    end

    describe "#session_id" do
      it "accepts an auth session id" do
        @client = AlsoEnergy::Client.new do |c|
          c.session_id = "totallynotnil"
        end
        @client.session_id.must_equal "totallynotnil"
      end
    end

    describe "#last_login" do
      it "accepts a sessionID timestamp" do
        @client = AlsoEnergy::Client.new do |c|
          c.last_login = Time.new(2015, 1, 1).to_i
        end
        @client.last_login.must_equal 1420099200
      end
    end
  end

  describe "the authentication process" do

    describe "#login" do
      before do
        VCR.insert_cassette "also_energy_invalid_login"
      end
      it "should return false for LoginFailed" do
        @client = AlsoEnergy::Client.new do |c|
          c.username = "thedoge"
          c.password = "12345"
          c.session_id = "totallynotnil"
          c.last_login = nil
        end
        @client.login.first.must_equal false
      end
    end
  end

end
