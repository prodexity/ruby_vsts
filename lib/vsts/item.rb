# VSTS namespace
module VSTS
  # Item model
  class Item < BaseModel
    attr_accessor :version, :path, :url

    # Create new item instance from a hash
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/changesets#get-list-of-changes-in-a-changeset
    #
    # @param h [Hash] item data as returned by the VSTS API
    def initialize(h = {})
      @version = h["version"]
      @path = h["path"]
      @url = h["url"]
    end

    def get
      resp = APIClient.get("/items", area: "tfvc", urlparams: { path: @path })
      resp.body
    end
  end
end
