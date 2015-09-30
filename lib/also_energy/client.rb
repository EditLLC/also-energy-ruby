require 'savon'
require 'pry'
require 'virtus'
require './lib/also_energy/hash_wrangler'
require './lib/also_energy/connection'
require './lib/also_energy/site'
require './lib/also_energy/hardware'

module AlsoEnergy

  class << self; attr_accessor :session_id; end

  class AuthError < StandardError; end;
  class QueryError < StandardError; end;

  class Client
    include HashWrangler
    include APIConnection

    attr_accessor :username, :password, :session_id

    def initialize()
      yield(self) if block_given?
    end

    def login
      message = { 'als:username' => username, 'als:password' => password }
      response = find_in_hash(:session_id, (connection.call(:login, message: message).body))
      response == nil ? (fail AuthError, "Login Failed!") : (self.session_id = response && AlsoEnergy.session_id = response)
    end

    def get_sites
      message = { 'als:sessionID' => session_id }
      response = find_in_hash(:items, (connection.call(:get_site_list, message: message).body))
      response == nil ? (fail QueryError, "Query Failed!") : (response.map{|site| AlsoEnergy::Site.new(site[1])})
    end

    def get_site_hardware(site_id)
      message = { 'als:sessionID' => session_id, 'als:siteID' => site_id }
      response = find_in_hash(:hardware_complete, (connection.call(:get_site_hardware_list, message: message).body))
      response == nil ? (fail QueryError, "Query Failed!") : (response.map{|hw| AlsoEnergy::HardWare.new(hw)})
    end

  end

end
binding.pry
