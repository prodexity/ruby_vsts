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

    # Convenience method to directly access item version
    def version
      @item.version
    end

    # Convenience method to directly access item path
    def path
      @item.path
    end

    # Convenience method to directly access item url
    def url
      @item.url
    end

    # Convenience method to directly download a change item (file)
    #
    # @param opts [Hash] options, see VSTS::Item#get
    # @return [String] the downloaded file contents
    def get(opts = nil)
      if opts.nil?
        @item.get
      else
        @item.get(opts)
      end
    end
  end
end
