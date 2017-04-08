# VSTS namespace
module VSTS
  # Changeset model
  class Changeset
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
      APIClient.get("/changesets", area: "tfvc", urlparams: urlparams)
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
      APIClient.get("/changesets/#{id}", area: "tfvc", urlparams: urlparams)
    end
  end
end
