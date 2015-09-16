require 'savon'
require './lib/also_energy/hash_wrangler'

module AlsoEnergy
  class AuthError < StandardError; end;

  class Client
    include HashWrangler

    attr_accessor :username, :password, :session_id

    def initialize
      yield(self) if block_given?
    end

    def login
      message = { username: username, password: password }
      response = connection.call(:login, message: message).body
      fail AuthError, "Login Failed!" if find_in_hash(:session_id, response) == nil
      self.session_id = find_in_hash(:session_id, response)
    end

    def connection
      @connect = Savon.client do |globals|
        globals.wsdl "http://www.alsoenergy.com/WebAPI/WebAPI.svc?wsdl"
        globals.endpoint "https://www.alsoenergy.com/WebAPI/WebAPI.svc"
        globals.namespace_identifier :als
        globals.env_namespace :soapenv
      end
    end
  end

end

# @client = AlsoEnergy::Client.new do |c|
#   c.username = "thedoge"
#   c.password = "12345"
#   c.session_id = "totallynotnil"
# end
