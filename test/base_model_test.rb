require 'test_helper'

# Test class for BaseModel
class TestBaseModel < MiniTest::Test
  def test_underscore
    m = VSTS::BaseModel.new
    assert_equal "abc_def", m.underscore("AbcDef")
    assert_equal "abc_def", m.underscore("abcDef")
    assert_equal "abc_def", m.underscore("ABCDef")
    assert_equal "abc_def_ghi", m.underscore("abcDefGhi")
  end
end
