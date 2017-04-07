require 'rest-client'
require 'base64'
require 'json'

# VSTS namespace
module VSTS
  # API client for Visual Studio Team Services (VSTS)
  # Manages access tokens and API versions, builds proper requests as expected by the VSTS API
  class APIClient
    attr_accessor :base_url
    attr_writer :personal_access_token # personal access token is write only
    attr_accessor :collection
    attr_accessor :team_project
    attr_accessor :area
    attr_accessor :api_version

    # Constructor for APIClient
    #
    # @param base_url [String] the base url for VSTS instance, ie. https://fabrikam.visualstudio.com
    # @param opts [Hash] options for the connection
    # @option opts [String] :personal_access_token Personal Access Token to be used in the requests (Basic auth)
    # @option opts [String] :api_version version of the Rest API to request (default: 1.0)
    # @option opts [String] :collection project collection to use (default: "DefaultCollection")
    # @option opts [String] :team_project team project to use (default: none)
    # @option opts [String] :area area to use (default: none)
    def initialize(base_url, opts = {}, rest_client = nil)
      @rest_client = rest_client || RestClient # Dependency Injection
      @base_url = base_url.sub(%r{\/+$}, "")
      @personal_access_token = opts[:personal_access_token] || ""
      @collection = opts[:collection] || "DefaultCollection"
      @team_project = opts[:team_project] || nil
      @area = opts[:area] || nil
      @api_version = opts["api_version"] || "1.0"
    end

    # Make an API request
    #
    # @param method [Symbol] the method to be used, can be :get, :put, :post, :delete or :head (will be passed to RestClient)
    # @param resource [String] the resource to request under the base_url (ie. "/changesets")
    # @param opts [Hash] options for the request, see #initialize for values, can have :payload and :urlparams in addition to that
    # @return [Hash] request results as parsed from json
    def request(method, resource, opts = {})
      resp = @rest_client::Request.execute(
        method: method,
        url: build_url(resource, opts),
        payload: opts[:payload],
        headers: { Authorization: authz_header_value, Accept: "application/json" }
      )
      JSON.parse(resp.body)
    end

    # Helper method for GET requests, calls #request
    #
    # @param resource [String] the resource to request under the base_url (ie. "/changesets")
    # @param opts [Hash] query options, see #request
    def get(resource, opts = {})
      request(:get, resource, opts)
    end

    # Helper method for POST requests, calls #request
    #
    # @param resource [String] the resource to request under the base_url (ie. "/changesets")
    # @param payload [Hash] payload to be sent with the request, takes precedence over opts[:payload]
    # @param opts [Hash] query options, see #request
    def post(resource, payload, opts = {})
      opts[:payload] = payload
      request(:post, resource, opts)
    end

    # Helper method for PUT requests, calls #request
    #
    # @param resource [String] the resource to request under the base_url (ie. "/changesets")
    # @param payload [Hash] payload to be sent with the request, takes precedence over opts[:payload]
    # @param opts [Hash] query options, see #request
    def put(resource, payload, opts = {})
      opts[:payload] = payload
      request(:put, resource, opts)
    end

    # Helper method for DELETE requests, calls #request
    #
    # @param resource [String] the resource to request under the base_url (ie. "/changesets")
    # @param opts [Hash] query options, see #request
    def delete(resource, opts = {})
      request(:delete, resource, opts)
    end

    private

    # Builds VSTS url as described in https://www.visualstudio.com/en-us/docs/integrate/get-started/rest/basics
    #
    # @param resource [String] the VSTS resource
    # @param opts [Hash] options hash, see #initialize for values, can have :urlparams in addition to that
    # @return [String] the request URL
    def build_url(resource, opts = {})
      api_version = opts[:api_version] || @api_version
      collection = opts[:collection] || @collection
      team_project = opts[:team_project] || @team_project
      urlparams = opts[:urlparams] || {}
      area = opts[:area] || @area
      resource.sub!(%r{^\/+}, "")

      base = [@base_url, collection, team_project, "_apis", area, resource].compact.join("/")
      urlparams["api-version"] ||= api_version
      url_encoded_params = URI.encode_www_form(urlparams)

      base + "?" + url_encoded_params
    end

    # Calculate the Authorization header for the API based on the personal access token
    #
    # @return [String] the Authorization header value for Basic auth, ie. "Basic jrigf9404vvxsoi48t048fdj=="
    def authz_header_value
      "Basic " + Base64.strict_encode64(":" + @personal_access_token)
    end
  end
end
