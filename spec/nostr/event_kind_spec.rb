# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::EventKind do
  describe '::SET_METADATA' do
    it 'is an integer' do
      expect(described_class::SET_METADATA).to eq(0)
    end
  end

  describe '::TEXT_NOTE' do
    it 'is an integer' do
      expect(described_class::TEXT_NOTE).to eq(1)
    end
  end

  describe '::RECOMMEND_SERVER' do
    it 'is an integer' do
      expect(described_class::RECOMMEND_SERVER).to eq(2)
    end
  end
end
