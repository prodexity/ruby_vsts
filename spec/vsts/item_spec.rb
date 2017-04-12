require "spec_helper"

# rubocop:disable Metrics/BlockLength
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
    # stub item download
    stub_request(:get, /test.visualstudio.local\/.*?\/items(\/|\?)/)
      .to_return(status: 200, body: "test file\ncontents")
  end

  let(:item) { VSTS::Changeset.find(16).changes[0].item }

  it "downloads from the correct URL" do
    expected_url = "https://test.visualstudio.local/DefaultCollection/_apis/tfvc/items"
    query = {
      "path" => "$/Fabrikam-Fiber-TFVC/AuthSample-dev/Code/AuthSample.cs",
      "api-version" => "1.0"
    }
    item.get
    expect(a_request(:get, expected_url).with(query: query)).to have_been_made.once
  end

  it "can be downloaded" do
    expect(item.get).to eq("test file\ncontents")
  end
end
# rubocop:enable Metrics/BlockLength
