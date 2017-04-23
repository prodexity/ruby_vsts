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

  let(:change) { VSTS::Changeset.find(16).changes[0] }
  let(:item) { change.item }
  let(:expected_url) { "https://test.visualstudio.local/DefaultCollection/_apis/tfvc/items" }

  it "downloads from the correct URL" do
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

  it "can download a specific version" do
    query = {
      "path" => "$/Fabrikam-Fiber-TFVC/AuthSample-dev/Code/AuthSample.cs",
      "versionType" => "changeset",
      "version" => 1000,
      "api-version" => "1.0"
    }
    item.get(versionType: :changeset, version: 1000)
    expect(a_request(:get, expected_url).with(query: query)).to have_been_made.once
  end

  it "can download the previous version before the latest" do
    query = {
      "path" => "$/Fabrikam-Fiber-TFVC/AuthSample-dev/Code/AuthSample.cs",
      "versionType" => "latest",
      "versionOptions" => "previous",
      "api-version" => "1.0"
    }
    item.get(versionType: :latest, versionOptions: :previous)
    expect(a_request(:get, expected_url).with(query: query)).to have_been_made.once
  end

  it "can download the previous version before a given changeset" do
    query = {
      "path" => "$/Fabrikam-Fiber-TFVC/AuthSample-dev/Code/AuthSample.cs",
      "versionType" => "changeset",
      "version" => 1000,
      "versionOptions" => "previous",
      "api-version" => "1.0"
    }
    item.get(versionType: :changeset, version: 1000, versionOptions: :previous)
    expect(a_request(:get, expected_url).with(query: query)).to have_been_made.once
  end

  describe "convenience methods (shortcuts)" do
    it "passes on #version to its Item and returns the same results" do
      expect(change.item.version).to eq(change.version)
    end

    it "passes on #path to its Item and returns the same results" do
      expect(change.item.path).to eq(change.path)
    end

    it "passes on #url to its Item and returns the same results" do
      expect(change.item.url).to eq(change.url)
    end

    it "passes on #get to its Item and returns the same results" do
      expect(change.item.get).to eq(change.get)
    end

    it "passes on #get to its Item with parameters and returns the same results" do
      expect(change.item.get(version: 123)).to eq(change.get(version: 123))
    end
  end
end
# rubocop:enable Metrics/BlockLength
