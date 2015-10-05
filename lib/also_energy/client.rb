require 'also_energy/hash_wrangler'
require 'also_energy/connection'
require 'also_energy/site'
require 'also_energy/hardware'

module AlsoEnergy
  class AuthError < StandardError; end
  class QueryError < StandardError; end

  class Client
    include HashWrangler
    include APIConnection

    attr_accessor :username, :password, :session_id

    def initialize
      yield(self) if block_given?
    end

    def login
      message = { 'als:username' => username, 'als:password' => password }
      response = find_in_hash(:session_id, (connection.call(:login, message: message).body))
      if response.nil?
        fail AuthError, 'Login Failed!'
      else
        self.session_id = response
      end
    end

    def get_sites
      message = { 'als:sessionID' => session_id }
      response = find_in_hash(:items, (connection.call(:get_site_list, message: message).body))
      if response.nil?
        fail QueryError, 'Query Failed!'
      else
        response.map { |site| AlsoEnergy::Site.new(site[1]) }
      end
    end

    def get_site_hardware(site_id)
      message = { 'als:sessionID' => session_id, 'als:siteID' => site_id }
      response = find_in_hash(:hardware_complete, (connection.call(:get_site_hardware_list, message: message).body))
      if response.nil?
        fail QueryError, 'Query Failed!'
      else
        response.each { |hw| hw[:session_id] = session_id }.map { |hw| AlsoEnergy::HardWare.new(hw) }
      end
    end
  end
end
