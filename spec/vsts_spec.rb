require 'spec_helper'

describe VSTS do
  describe 'versioning' do
    it 'has a proper version' do
      expect(VSTS::VERSION).to match(/\A\d+\.\d+\.\d+(-\w+)?\z/)
    end
  end

  describe 'logging' do
    it 'has a logger' do
      expect(described_class.logger).to be_a(Logger)
    end
  end
end
