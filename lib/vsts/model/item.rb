# VSTS namespace
module VSTS
  # Item model
  class Item < BaseModel
    attr_accessor :version, :path, :url

    # Create new item instance from a hash
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/changesets#get-list-of-changes-in-a-changeset
    #
    # @param h [Hash] item data as returned by the VSTS API
    def initialize(item = {})
      @version = item["version"]
      @path = item["path"]
      @url = item["url"]
    end

    # Download TFVC item (ie. the file itself)
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/items#get-a-file
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/items#get-a-specific-version
    #
    # @param opts [Hash] options
    # @option opts [Symbol] :versionType requested version type (the version parameter is the version of this);
    #                                    can be :branch, :changeset, :shelveset, :change, :date, :mergeSource, :latest
    # @option opts [int] :version the requested version number
    # @option opts [Symbol, nil] :versionOptions can be specified as :previous to get the previous version to the one specified
    # @return [String] the downloaded file contents
    def get(opts = {})
      urlparams = APIClient.build_params(opts, [:versionType, :version, :versionOptions])
      urlparams[:path] = @path
      resp = APIClient.get("/items", area: "tfvc", urlparams: urlparams, accept: "application/binary")
      resp.body
    end
  end
end
