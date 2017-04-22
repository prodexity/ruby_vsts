# VSTS namespace
module VSTS
  # Shelveset model
  class Shelveset < BaseModel
    attr_accessor :id, :name, :url, :owner, :created_date, :comment

    # Create new shelveset instance from a hash
    #
    # @param h [Hash] shelveset data as returned by the VSTS API
    def initialize(h = {})
      @id = h["id"]
      @name = h["name"]
      @url = h["url"]
      @owner = Identity.new(h["owner"])
      @created_date = DateTime.rfc3339(h["createdDate"])
      @comment = h["comment"]
      @_changes = nil
    end

    # Get changes in the shelveset
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/shelvesets#get-shelveset-changes
    #
    # @param opts [Hash]
    # @return [array of Change] list of changes in the shelveset
    def changes(opts = {})
      return @_changes if @_changes.instance_of?(Array)
      urlparams = APIClient.build_params(opts, [["$", :top], ["$", :skip]])
      resp = APIClient.get("/shelvesets/#{id}/changes", area: "tfvc", urlparams: urlparams)
      @_changes = resp.parsed["changes"].map { |o| Change.new(o) }
    end

    # List shelvesets
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/shelvesets#get-list-of-shelvesets
    #
    # @param params [Hash]
    # @return [array of Shelveset] search results
    def self.find_all(params = {})
      urlparams = APIClient.build_params(
        params,
        [
          :owner,
          :maxCommentLength,
          ["$", :top],
          ["$", :skip]
        ]
      )
      resp = APIClient.get("/shelvesets", area: "tfvc", urlparams: urlparams)
      resp.parsed["value"].map { |o| Shelveset.new(o) }
    end

    # Find specific shelveset by name and owner
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/shelvesets#get-a-shelveset
    #
    # @param name [String] shelveset name
    # @param owner [String] shelveset owner (unique guid, display name or email)
    # @param opts [Hash] options
    # @option opts [int] :maxCommentLength
    # @option opts [int] :maxChangeCount
    # @option opts [boolean] :includeDetails
    # @option opts [boolean] :includeWorkItems
    # @return [Shelveset, nil] the shelveset found or nil
    def self.find_by_name(name, owner, opts = {})
      urlparams = APIClient.build_params(opts, [:includeDetails, :includeWorkItems, :maxCommentLength, :maxChangeCount])
      resp = APIClient.get("/shelvesets/#{name};#{owner}", area: "tfvc", urlparams: urlparams)
      Shelveset.new(resp.parsed)
    end

    # Find specific shelveset by id
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/shelvesets#get-a-shelveset
    #
    # @param name [String] shelveset id
    # @param opts [Hash] options
    # @option opts [int] :maxCommentLength
    # @option opts [int] :maxChangeCount
    # @option opts [boolean] :includeDetails
    # @option opts [boolean] :includeWorkItems
    # @return [Shelveset, nil] the shelveset found or nil
    def self.find(id, opts = {})
      urlparams = APIClient.build_params(opts, [:includeDetails, :includeWorkItems, :maxCommentLength, :maxChangeCount])
      resp = APIClient.get("/shelvesets/#{id}", area: "tfvc", urlparams: urlparams)
      Shelveset.new(resp.parsed)
    end
  end
end
