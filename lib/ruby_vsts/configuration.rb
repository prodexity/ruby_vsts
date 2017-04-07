# VSTS namespace
module VSTS
  # Configuration class for ruby_vsts
  class Configuration
    attr_accessor :personal_access_token
    attr_accessor :base_url, :collection, :team_project, :area, :api_version

    def initialize
      @personal_access_token = ""
      @base_url = ""
      @collection = "DefaultCollection"
      @team_project = nil
      @area = nil
      @api_version = "1.0"
    end
  end
end
