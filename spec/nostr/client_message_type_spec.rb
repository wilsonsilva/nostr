# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::ClientMessageType do
  describe '::EVENT' do
    it 'is a string' do
      expect(described_class::EVENT).to eq('EVENT')
    end
  end

  describe '::REQ' do
    it 'is a string' do
      expect(described_class::REQ).to eq('REQ')
    end
  end

  describe '::CLOSE' do
    it 'is a string' do
      expect(described_class::CLOSE).to eq('CLOSE')
    end
  end
end
