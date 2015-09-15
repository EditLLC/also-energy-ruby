require 'savon'
require './lib/also_energy/hash_wrangler'

module AlsoEnergy
  
  class Client
    include HashWrangler

    attr_accessor :username, :password, :session_id, :last_login

    def initialize
      yield(self) if block_given?
    end

    def login
      message = { username: username, password: password }
      response = connection.call(:login, message: message).body
      if find_in_hash(:session_id, response) == nil
        return false, "Error! Code #{find_in_hash(:code, response)} #{find_in_hash(:string_code, response)}"
      else
        self.session_id = find_in_hash(:session_id, response)
        self.last_login = Time.now.to_i
        return true, "Success!"
      end
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
#   c.last_login = nil
# end
