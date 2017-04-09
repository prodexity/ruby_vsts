require 'spec_helper'

describe VSTS::Configuration do
  before do
    VSTS.configure do |config|
      config.personal_access_token = "test_token"
      config.base_url = "https://testurl.local/"
      config.collection = "testcollection"
      config.team_project = "testproject"
      config.area = "testarea"
      config.api_version = "9.9-test"
      config.debug = true
    end
  end

  it 'has an accessible configuration' do
    expect(VSTS.configuration).to be_a(described_class)
  end

  it 'has its fields configured' do
    expect(VSTS.configuration.personal_access_token).to eq("test_token")
    expect(VSTS.configuration.base_url).to eq("https://testurl.local/")
    expect(VSTS.configuration.collection).to eq("testcollection")
    expect(VSTS.configuration.team_project).to eq("testproject")
    expect(VSTS.configuration.area).to eq("testarea")
    expect(VSTS.configuration.api_version).to eq("9.9-test")
    expect(VSTS.configuration.debug).to eq(true)
  end

  it 'can be reconfigured' do
    VSTS.configuration.debug = false
    expect(VSTS.configuration.debug).to eq(false)
  end

  it 'can be reset' do
    VSTS.reset
    expect(VSTS.configuration.personal_access_token).to eq("")
    expect(VSTS.configuration.base_url).to eq("")
  end
end
