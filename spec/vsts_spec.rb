require 'spec_helper'

describe VSTS do
  describe 'logging' do
    it 'has a version' do
      expect(VSTS::VERSION).to match(/\A\d+\.\d+\.\d+(-\w+)?\z/)
    end

    it 'has a logger' do
      expect(described_class.logger).to be_a(Logger)
    end
  end
end
