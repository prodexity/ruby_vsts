require 'vsts/version'
require 'vsts/configuration'
require 'vsts/api_client'
require 'vsts/api_response'
require 'vsts/model/base_model'
Dir[File.dirname(__FILE__) + '/vsts/model/*.rb'].each { |file| require file }

# Base namespace for ruby_vsts
module VSTS
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
