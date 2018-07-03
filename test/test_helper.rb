$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "adobe_sign"
require "pry"

require 'minitest/autorun'
require 'minitest/reporters'

require 'vcr'
require 'webmock'

VCR.configure do |c|
  c.cassette_library_dir = File.dirname(__FILE__) + '/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { record: :none, decode_compressed_response: true }
end

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new slow_count: 10, color: true
