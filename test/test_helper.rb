$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require './lib/also_energy'
require 'minitest/autorun'
require 'webmock/minitest'
require 'minitest/reporters'
# require 'vcr'
require 'pry'

# VCR.configure do |c|
#   c.cassette_library_dir = "test/fixtures"
#   c.hook_into :webmock
# end
