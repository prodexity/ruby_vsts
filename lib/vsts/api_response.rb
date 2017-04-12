require 'json'

# VSTS namespace
module VSTS
  # VSTS API response
  class APIResponse
    attr_accessor :request, :code, :body, :parsed

    # Constructor
    #
    # @param request [Hash] the hash that was passed to RestClient as the request descriptor
    # @param response [RestClient::Response]
    def initialize(request, response)
      @request = request
      @code = response.code
      @body = response.body
      begin
        @parsed = JSON.parse(@body)
      rescue JSON::ParserError
        @parsed = nil
      end
    end
  end
end
