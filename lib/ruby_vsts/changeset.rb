# VSTS namespace
module VSTS
  # Changeset model
  class Changeset < BaseModel
    attr_accessor :id, :url, :author, :checked_in_by, :created_date, :comment

    def initialize(h = {})
      @id = h["changesetId"]
      @url = h["url"]
      @author = Identity.new(h["author"])
      @checked_in_by = Identity.new(h["checkedInBy"])
      @created_date = DateTime.rfc3339(h["createdDate"])
      @comment = h["comment"]
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
          ["$", :orderby],
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
