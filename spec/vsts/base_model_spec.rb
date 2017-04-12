require "spec_helper"

describe VSTS::BaseModel do
  it "can convert camelcase to underlines" do
    m = described_class.new
    expect(m.underscore("AbcDef")).to eq("abc_def")
    expect(m.underscore("ABCDef")).to eq("abc_def")
    expect(m.underscore("abcDefGhi")).to eq("abc_def_ghi")
  end
end
