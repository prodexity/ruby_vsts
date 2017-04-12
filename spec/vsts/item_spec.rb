require "spec_helper"

describe VSTS::Item do
  before do
    VSTS.reset
    VSTS.configure do |config|
      config.personal_access_token = "test_token"
      config.base_url = "https://test.visualstudio.local/"
      config.debug = false
    end

    # stub one changeset
    stub_request(:get, /test.visualstudio.local\/.*?\/changesets\/\d+\?/)
      .to_return(status: 200, body: File.new(fixtures_path + "tfvc_changeset_by_id.json"))
    # stub changes in a changeset
    stub_request(:get, /test.visualstudio.local\/.*?\/changesets\/\d+\/changes\?/)
      .to_return(status: 200, body: File.new(fixtures_path + "tfvc_changeset_changes.json"))
  end

  let(:item) { VSTS::Changeset.find(16).changes[0] }

end
