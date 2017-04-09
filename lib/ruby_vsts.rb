require 'vsts/configuration'
require 'vsts/api_client'
require 'vsts/api_response'
require 'vsts/base_model'
require 'vsts/identity'
require 'vsts/item'
require 'vsts/change'
require 'vsts/changeset'

# Base namespace for ruby_vsts
module VSTS
  class << self
    attr_accessor :configuration
    attr_accessor :logger
  end

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
