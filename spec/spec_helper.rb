require 'rspec'
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

require 'ruby_vsts'
