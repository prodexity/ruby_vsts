require 'spec_helper'

describe VSTS do
  describe 'logging' do
    it 'has a logger' do
      expect(described_class.logger).to be_a(Logger)
    end
  end
end
