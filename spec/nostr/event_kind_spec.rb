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

  describe '::CONTACT_LIST' do
    it 'is an integer' do
      expect(described_class::CONTACT_LIST).to eq(3)
    end
  end

  describe '::ENCRYPTED_DIRECT_MESSAGE' do
    it 'is an integer' do
      expect(described_class::ENCRYPTED_DIRECT_MESSAGE).to eq(4)
    end
  end

  describe '::ZAP_REQUEST' do
    it 'is an integer' do
      expect(described_class::ZAP_REQUEST).to eq(9734)
    end
  end

  describe '::ZAP_RECEIPT' do
    it 'is an integer' do
      expect(described_class::ZAP_RECEIPT).to eq(9735)
    end
  end
end
