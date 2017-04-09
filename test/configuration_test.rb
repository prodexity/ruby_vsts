require 'test_helper'

# Test class for the configuration
class TestConfiguration < MiniTest::Test
  def setup
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

  def test_personal_access_token
    assert_equal "test_token", VSTS.configuration.personal_access_token
  end

  def test_base_url
    assert_equal "https://testurl.local/", VSTS.configuration.base_url
  end

  def test_collection
    assert_equal "testcollection", VSTS.configuration.collection
  end

  def test_team_project
    assert_equal "testproject", VSTS.configuration.team_project
  end

  def test_area
    assert_equal "testarea", VSTS.configuration.area
  end

  def test_api_version
    assert_equal "9.9-test", VSTS.configuration.api_version
  end

  def test_debug
    assert_equal true, VSTS.configuration.debug
    VSTS.configuration.debug = false
    assert_equal false, VSTS.configuration.debug
  end

  def test_reset_configuration
    VSTS.reset
    assert_equal "", VSTS.configuration.personal_access_token
    assert_equal "", VSTS.configuration.base_url
    assert_equal "DefaultCollection", VSTS.configuration.collection
    assert_equal nil, VSTS.configuration.team_project
    assert_equal nil, VSTS.configuration.area
    assert_equal "1.0", VSTS.configuration.api_version
    assert_equal true, VSTS.configuration.debug
  end
end
