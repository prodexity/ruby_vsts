# VSTS namespace
module VSTS
  # Changeset model
  class Changeset < BaseModel
    attr_accessor :id, :url, :author, :checked_in_by, :created_date, :comment

    # Create new changeset instance from a hash
    #
    # @param h [Hash] changeset data as returned by the VSTS API
    def initialize(h = {})
      @id = h["changesetId"]
      @url = h["url"]
      @author = Identity.new(h["author"])
      @checked_in_by = Identity.new(h["checkedInBy"])
      @created_date = DateTime.rfc3339(h["createdDate"])
      @comment = h["comment"]
      @_changes = nil
    end

    # Get changes in the changeset
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/changesets#get-list-of-changes-in-a-changeset
    #
    # @param opts [Hash]
    # @return [array of Change] list of changes in the changeset
    def changes(opts = {})
      return @_changes if @_changes.instance_of?(Array)
      urlparams = APIClient.build_params(opts, [["$", :top], ["$", :skip]])
      resp = APIClient.get("/changesets/#{id}/changes", area: "tfvc", urlparams: urlparams)
      @_changes = resp.parsed["value"].map { |o| Change.new(o) }
    end

    # List changesets
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/changesets#get-list-of-changesets
    #
    # @param search_criteria [Hash]
    # @return [array of Changeset] search results
    def self.find_all(search_criteria = {})
      urlparams = APIClient.build_params(
        search_criteria,
        [
          ["searchCriteria.", :itemPath],
          ["searchCriteria.", :version],
          ["searchCriteria.", :versionType],
          ["searchCriteria.", :versionOption],
          ["searchCriteria.", :author],
          ["searchCriteria.", :fromId],
          ["searchCriteria.", :toId],
          ["searchCriteria.", :fromDate],
          ["searchCriteria.", :toDate],
          ["$", :top],
          ["$", :skip],
          ["$", :orderBy],
          :maxCommentLength
        ]
      )
      resp = APIClient.get("/changesets", area: "tfvc", urlparams: urlparams)
      resp.parsed["value"].map { |o| Changeset.new(o) }
    end

    # Find specific changeset by id
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/changesets#get-a-changeset
    #
    # @param id [int] the changeset id
    # @param opts [Hash] options
    # @option opts [int] :maxCommentLength
    # @option opts [int] :maxChangeCount
    # @option opts [boolean] :includeDetails
    # @option opts [boolean] :includeWorkItems
    # @return [Changeset, nil] the changeset found or nil
    def self.find(id, opts = {})
      urlparams = APIClient.build_params(opts, [:includeDetails, :includeWorkItems, :maxCommentLength, :maxChangeCount])
      resp = APIClient.get("/changesets/#{id}", area: "tfvc", urlparams: urlparams)
      Changeset.new(resp.parsed)
    end
  end
end
