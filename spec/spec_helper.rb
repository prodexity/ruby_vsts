require 'rspec'
require 'webmock/rspec'
require 'simplecov'
require 'simplecov-json'
require 'codeclimate-test-reporter'

SimpleCov.configure do
  root File.join(File.dirname(__FILE__), '..')
  project_name 'Ruby VSTS Client'
  add_filter 'spec'
end

SimpleCov.start

RSpec.configure do |config|
  config.order = 'random'
end

WebMock.disable_net_connect!

require 'ruby_vsts'

def fixtures_path
  File.dirname(__FILE__) + '/fixtures/'
end
