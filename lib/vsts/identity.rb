# VSTS namespace
module VSTS
  # User (person) model
  class Identity < BaseModel
    attr_accessor :id, :display_name, :unique_name, :url, :image_url

    # Create Identity from allowed hash values
    def initialize(identity_hash = {})
      identity_hash.select! { |k, _v| %w[id displayName uniqueName url imageUrl].include?(k) }
      identity_hash.each do |k, v|
        usk = underscore(k)
        public_send("#{usk}=", v)
      end
    end
  end
end
