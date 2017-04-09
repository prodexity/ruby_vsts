# VSTS namespace
module VSTS
  # Change model
  class Change < BaseModel
    attr_accessor :change_type, :item

    # Create new change instance from a hash
    # See https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/changesets#get-list-of-changes-in-a-changeset
    #
    # @param h [Hash] change data as returned by the VSTS API
    def initialize(h = {})
      @change_type = h["changeType"]
      @item = Item.new(h["item"])
    end
  end
end
