require 'ruby_vsts/configuration'
require 'ruby_vsts/api_client'
require 'ruby_vsts/changeset'
require 'ruby_vsts/item'

# Base namespace for ruby_vsts
module VSTS
  class << self
    attr_accessor :configuration
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
end
