require "spec_helper"

# rubocop:disable Metrics/BlockLength
describe VSTS::Shelveset do
  before do
    VSTS.reset
    VSTS.configure do |config|
      config.personal_access_token = "test_token"
      config.base_url = "https://test.visualstudio.local/"
      config.debug = false
    end
  end

  let(:expected_url) { "https://test.visualstudio.local/DefaultCollection/_apis/tfvc/shelvesets" }

  describe "finding a single shelveset" do
    before do
      # stub one changeset
      stub_request(:get, /test.visualstudio.local\/.*?\/shelvesets\/[^\/\?]+\?/)
        .to_return(status: 200, body: File.new(fixtures_path + "tfvc_shelveset_by_id.json"))
    end

    it "can find a Shelveset instance by name and owner" do
      described_class.find_by_name("Abc def", "12345")
      query = {
        "api-version" => "1.0"
      }
      expect(a_request(:get, expected_url + "%2FAbc\%20def;12345").with(query: query)).to have_been_made.once
    end

    let(:shelveset) { described_class.find("My first shelveset;d6245f20-2af8-44f4-9451-8107cb2767db") }

    it "can find a Shelveset instance by id" do
      expect(shelveset).to be_a(described_class)
    end

    it "can fill in Shelveset instance fields from the response" do
      expect(shelveset.name).to eq("My first shelveset")
    end

    it "can download changes" do
      expect(shelveset).to respond_to(:changes)
    end
  end

  describe "finding a list of shelvesets" do
    before do
      # stub list of shelvesets (the same response for any query)
      stub_request(:get, /test.visualstudio.local\/.*?\/shelvesets\?/)
        .to_return(status: 200, body: File.new(fixtures_path + "tfvc_shelvesets_list.json"))
    end

    let(:expected_url) { "https://test.visualstudio.local/DefaultCollection/_apis/tfvc/shelvesets" }

    it "can find a list of changesets as an array" do
      shelveset_list = described_class.find_all
      expect(shelveset_list).to be_an(Array)
      expect(shelveset_list[0]).to be_a(described_class)
    end

    it "can find all changesets" do
      changeset_list = described_class.find_all
      expect(changeset_list.length).to eq(3)
    end

    it "can request a page at a time" do
      described_class.find_all(top: 20, skip: 100)
      query = {
        "$top" => 20,
        "$skip" => 100,
        "api-version" => "1.0"
      }
      expect(a_request(:get, expected_url).with(query: query)).to have_been_made.once
    end

    describe "filtering" do
      it "can filter by owner" do
        described_class.find_all(owner: "Normal Paulk") # can be display name, email or unique guid
        query = {
          "owner" => "Normal Paulk",
          "api-version" => "1.0"
        }
        expect(a_request(:get, expected_url).with(query: query)).to have_been_made.once
      end
    end
  end

  describe "downloading changes in a shelveset" do
    before do
      # stub one shelveset
      stub_request(:get, /test.visualstudio.local\/.*?\/shelvesets\/[^\/\?]+\?/)
        .to_return(status: 200, body: File.new(fixtures_path + "tfvc_shelveset_by_id.json"))
      # stub changes in a shelveset
      stub_request(:get, /test.visualstudio.local\/.*?\/shelvesets\/[^\/\?]+\/changes\?/)
        .to_return(status: 200, body: File.new(fixtures_path + "tfvc_shelveset_changes.json"))
    end

    let(:changes) { described_class.find("My first shelveset;d6245f20-2af8-44f4-9451-8107cb2767db").changes }

    it "can get changes as an Array" do
      expect(changes).to be_an(Array)
    end

    it "creates the required amount of changes" do
      expect(changes.length).to eq(4)
    end

    it "creates Change instances" do
      expect(changes[0]).to be_a(VSTS::Change)
    end
  end
end
# rubocop:enable Metrics/BlockLength
