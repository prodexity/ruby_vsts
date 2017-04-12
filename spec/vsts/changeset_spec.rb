require "spec_helper"

# rubocop:disable Metrics/BlockLength
describe VSTS::Changeset do
  before do
    VSTS.reset
    VSTS.configure do |config|
      config.personal_access_token = "test_token"
      config.base_url = "https://test.visualstudio.local/"
      config.debug = false
    end
  end

  describe "finding a single changeset" do
    before do
      # stub one changeset
      stub_request(:get, /test.visualstudio.local\/.*?\/changesets\/\d+\?/)
        .to_return(status: 200, body: File.new(fixtures_path + "tfvc_changeset_by_id.json"))
    end

    let(:changeset) { described_class.find(16) }

    it "can find a Changeset instance by id" do
      expect(changeset).to be_a(described_class)
    end

    it "can create an Identity instance for the author of the changeset" do
      expect(changeset.author).to be_a(VSTS::Identity)
    end

    it "can fill in Changeset instance fields from the response" do
      expect(changeset.author.display_name).to eq("Chuck Reinhart")
    end

    it "can download changes" do
      expect(changeset).to respond_to(:changes)
    end
  end

  describe "finding a list of changesets" do
    before do
      # stub list of changesets (the same response for any query)
      stub_request(:get, /test.visualstudio.local\/.*?\/changesets\?/)
        .to_return(status: 200, body: File.new(fixtures_path + "tfvc_changesets_list.json"))
    end

    let(:expected_url) { "https://test.visualstudio.local/DefaultCollection/_apis/tfvc/changesets" }

    it "can find a list of changesets as an array" do
      changeset_list = described_class.find_all
      expect(changeset_list).to be_an(Array)
      expect(changeset_list[0]).to be_a(described_class)
    end

    it "can find all changesets" do
      changeset_list = described_class.find_all
      expect(changeset_list.length).to eq(18)
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

    it "can sort results" do
      described_class.find_all(orderBy: "id desc")
      query = {
        "$orderBy" => "id desc",
        "api-version" => "1.0"
      }
      expect(a_request(:get, expected_url).with(query: query)).to have_been_made.once
    end

    describe "filtering" do
      it "can filter by item path" do
        described_class.find_all(itemPath: "$/Fabrikam-Fiber-TFVC/Program.cs")
        query = {
          "searchCriteria.itemPath" => "$/Fabrikam-Fiber-TFVC/Program.cs",
          "api-version" => "1.0"
        }
        expect(a_request(:get, expected_url).with(query: query)).to have_been_made.once
      end

      it "can filter by author" do
        described_class.find_all(author: "fabrikamfiber3@hotmail.com")
        query = {
          "searchCriteria.author" => "fabrikamfiber3@hotmail.com",
          "api-version" => "1.0"
        }
        expect(a_request(:get, expected_url).with(query: query)).to have_been_made.once
      end

      it "can filter by range of IDs" do
        described_class.find_all(fromId: 10, toId: 20)
        query = {
          "searchCriteria.fromId" => 10,
          "searchCriteria.toId" => 20,
          "api-version" => "1.0"
        }
        expect(a_request(:get, expected_url).with(query: query)).to have_been_made.once
      end

      it "can filter by date range" do
        described_class.find_all(fromDate: "03-01-2017", toDate: "03-18-2017-2:00PM")
        query = {
          "searchCriteria.fromDate" => "03-01-2017",
          "searchCriteria.toDate" => "03-18-2017-2:00PM",
          "api-version" => "1.0"
        }
        expect(a_request(:get, expected_url).with(query: query)).to have_been_made.once
      end
    end
  end

  describe "downloading changes in a changeset" do
    before do
      # stub one changeset
      stub_request(:get, /test.visualstudio.local\/.*?\/changesets\/\d+\?/)
        .to_return(status: 200, body: File.new(fixtures_path + "tfvc_changeset_by_id.json"))
      # stub changes in a changeset
      stub_request(:get, /test.visualstudio.local\/.*?\/changesets\/\d+\/changes\?/)
        .to_return(status: 200, body: File.new(fixtures_path + "tfvc_changeset_changes.json"))
    end

    let(:changes) { described_class.find(16).changes }

    it "can get changes as an Array" do
      expect(changes).to be_an(Array)
    end

    it "creates the required amount of changes" do
      expect(changes.length).to eq(1)
    end

    it "creates Change instances" do
      expect(changes[0]).to be_a(VSTS::Change)
    end
  end
end
# rubocop:enable Metrics/BlockLength
