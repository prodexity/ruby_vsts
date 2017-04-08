require 'rest-client'
require 'base64'
require 'json'

# VSTS namespace
module VSTS
  # API client for Visual Studio Team Services (VSTS)
  # Manages access tokens and API versions, builds proper requests as expected by the VSTS API
  class APIClient
    # Make an API request
    #
    # @param method [Symbol] the method to be used, can be :get, :put, :post, :delete or :head (will be passed to RestClient)
    # @param resource [String] the resource to request under the base_url (ie. "/changesets")
    # @param opts [Hash] options for the request
    # @option opts [Hash] :payload payload for the request (if any)
    # @option opts [String] :api_version
    # @option opts [String] :collection
    # @option opts [String] :team_project
    # @option opts [String] :area
    # @option opts [Hash] :urlparams
    # @return [Hash] request results as parsed from json
    def self.request(method, resource, opts = {})
      url = build_url(resource, opts)
      VSTS.logger.debug("VSTS request: #{method} #{url}") if VSTS.configuration.debug
      resp = RestClient::Request.execute(
        method: method,
        url: url,
        payload: opts[:payload],
        headers: {
          Authorization: authz_header_value,
          Accept: "application/json",
          "Content-Type" => "application/json"
        }
      )
      JSON.parse(resp.body)
    end

    # Helper method for GET requests, calls #request
    #
    # @param resource [String] the resource to request under the base_url (ie. "/changesets")
    # @param opts [Hash] query options, see #request
    # @return [Hash] request results as parsed from json
    def self.get(resource, opts = {})
      request(:get, resource, opts)
    end

    # Helper method for POST requests, calls #request
    #
    # @param resource [String] the resource to request under the base_url (ie. "/changesets")
    # @param payload [Hash] payload to be sent with the request, takes precedence over opts[:payload]
    # @param opts [Hash] query options, see #request
    # @return [Hash] request results as parsed from json
    def self.post(resource, payload, opts = {})
      opts[:payload] = payload
      request(:post, resource, opts)
    end

    # Helper method for PUT requests, calls #request
    #
    # @param resource [String] the resource to request under the base_url (ie. "/changesets")
    # @param payload [Hash] payload to be sent with the request, takes precedence over opts[:payload]
    # @param opts [Hash] query options, see #request
    # @return [Hash] request results as parsed from json
    def self.put(resource, payload, opts = {})
      opts[:payload] = payload
      request(:put, resource, opts)
    end

    # Helper method for PATCH requests, calls #request
    #
    # @param resource [String] the resource to request under the base_url (ie. "/changesets")
    # @param payload [Hash] payload to be sent with the request, takes precedence over opts[:payload]
    # @param opts [Hash] query options, see #request
    # @return [Hash] request results as parsed from json
    def self.patch(resource, payload, opts = {})
      opts[:payload] = payload
      request(:patch, resource, opts)
    end

    # Helper method for DELETE requests, calls #request
    #
    # @param resource [String] the resource to request under the base_url (ie. "/changesets")
    # @param opts [Hash] query options, see #request
    # @return [Hash] request results as parsed from json
    def self.delete(resource, opts = {})
      request(:delete, resource, opts)
    end

    # Private class methods

    # Builds VSTS url as described in https://www.visualstudio.com/en-us/docs/integrate/get-started/rest/basics
    #
    # @param resource [String] the VSTS resource
    # @param opts [Hash] options hash, see #request
    # @return [String] the request URL
    # @private
    def self.build_url(resource, opts = {})
      base_url = VSTS.configuration.base_url.sub(%r{\/+$}, "")
      api_version = opts[:api_version] || VSTS.configuration.api_version
      collection = opts[:collection] || VSTS.configuration.collection
      team_project = opts[:team_project] || VSTS.configuration.team_project
      urlparams = opts[:urlparams] || {}
      area = opts[:area] || VSTS.configuration.area
      resource.sub!(%r{^\/+}, "")

      base = [base_url, collection, team_project, "_apis", area, resource].compact.join("/")
      urlparams["api-version"] ||= api_version
      url_encoded_params = URI.encode_www_form(urlparams) # makes url params from Hash

      base + "?" + url_encoded_params
    end

    # Calculate the Authorization header for the API based on the personal access token
    #
    # @return [String] the Authorization header value for Basic auth, ie. "Basic jrigf9404vvxsoi48t048fdj=="
    # @private
    def self.authz_header_value
      "Basic " + Base64.strict_encode64(":" + VSTS.configuration.personal_access_token)
    end

    # Build URL parameters hash from options hash (used internally)
    #
    # @param opts [Hash] options hash with Symbol keys to build url parameters from
    # @param paramnames [Array<String>, Array<Symbol>, Array<Array<String, String>>, Array<Hash>]
    #                   list of VSTS URL parameter names and VSTS prefixes to filter from opts
    # @return [Hash] url parameters hash
    # @private
    def self.build_params(opts, paramnames)
      urlparams = {}
      paramnames.each do |paramname_with_prefix|
        case paramname_with_prefix
        when String, Symbol
          prefix = ""
          paramname = paramname_with_prefix
        when Array
          prefix = paramname_with_prefix[0]
          paramname = paramname_with_prefix[1]
        when Hash
          prefix = paramname_with_prefix.first[0]
          paramname = paramname_with_prefix.first[1]
        else
          VSTS.logger.warn("Invalid type in paramlist in APIClient##build_params: #{paramname_with_prefix.class}")
          next
        end
        urlparams["#{prefix}#{paramname}"] = opts[paramname] if opts[paramname]
      end
      urlparams
    end
  end
end
