require 'savon'
require 'pry'
require './lib/also_energy/attrs'
require './lib/also_energy/hash_wrangler'
require './lib/also_energy/site'

module AlsoEnergy
  class AuthError < StandardError; end;
  class QueryError < StandardError; end;

  class Client
    include HashWrangler

    attr_accessor :username, :password, :session_id, :site_objects

    def initialize(site_objects = [])
      @site_objects = site_objects
      yield(self) if block_given?
    end

    def login
      message = { 'als:username' => username, 'als:password' => password }
      response = find_in_hash(:session_id, (connection.call(:login, message: message).body))
      response == nil ? (fail AuthError, "Login Failed!") : (self.session_id = response)
    end

    def get_sites
      message = { 'als:sessionID' => session_id }
      response = find_in_hash(:items, (connection.call(:get_site_list, message: message).body))
      fail QueryError, "Query Failed!" if response == nil
      response.each do |site|
        @new_site = AlsoEnergy::Site.new do |c|
          c.attrs.each{|attr| c.instance_variable_set("@#{attr}".to_sym, find_in_hash(attr.to_sym, site)) }
        end
        site_objects.push(@new_site)
      end
      return site_objects
    end

    def connection
      @connect = Savon.client do |globals|
        globals.wsdl "http://www.alsoenergy.com/WebAPI/WebAPI.svc?wsdl"
        globals.endpoint "https://www.alsoenergy.com/WebAPI/WebAPI.svc"
        globals.env_namespace :soapenv
        globals.namespace_identifier :als
        globals.pretty_print_xml true
        globals.log true
      end
    end
  end

end
