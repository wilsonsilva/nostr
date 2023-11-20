# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::InvalidKeyTypeError do
  describe '#initialize' do
    let(:key_kind) { 'private' }
    let(:error) { described_class.new(key_kind) }

    it 'builds a useful error message' do
      expect(error.message).to eq('Invalid private key type')
    end
  end
end
