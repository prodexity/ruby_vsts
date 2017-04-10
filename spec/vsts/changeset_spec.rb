require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe VSTS::Changeset do
  before do
    VSTS.reset
    VSTS.configure do |config|
      config.personal_access_token = "test_token"
      config.base_url = "https://test.visualstudio.local/"
      config.debug = false
    end

    # one changeset
    stub_request(:get, /test.visualstudio.local\/.*?\/changesets\/\d+\?/)
      .to_return(status: 200, body: File.new(fixtures_path + "tfvc_changeset_by_id.json"))

    # list of changesets
    stub_request(:get, /test.visualstudio.local\/.*?\/changesets\?/)
      .to_return(status: 200, body: File.new(fixtures_path + "tfvc_changesets_list.json"))
  end

  describe 'finding a single changeset' do
    it 'can find a Changeset instance by id' do
      changeset = described_class.find(16)
      expect(changeset).to be_a(described_class)
    end

    it 'can create an Identity instance for the author of the changeset' do
      changeset = described_class.find(16)
      expect(changeset.author).to be_a(VSTS::Identity)
    end

    it 'can fill in Changeset instance fields from the response' do
      changeset = described_class.find(16)
      expect(changeset.author.display_name).to eq("Chuck Reinhart")
    end
  end

  describe 'finding a list of changesets' do
    it 'can find a list of changesets as an array' do
      changeset_list = described_class.find_all
      expect(changeset_list).to be_an(Array)
    end

    it 'parses all elements of the reponse' do
      changeset_list = described_class.find_all
      expect(changeset_list.length).to eq(18)
    end
  end
end
# rubocop:enable Metrics/BlockLength
