require 'test_helper'

# Test class for the main module definition
class TestVSTS < MiniTest::Test
  def test_logger
    assert VSTS.logger.instance_of? Logger
  end
end
