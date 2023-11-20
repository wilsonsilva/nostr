# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::InvalidKeyFormatError do
  describe '#initialize' do
    let(:key_kind) { 'private' }
    let(:error) { described_class.new(key_kind) }

    it 'builds a useful error message' do
      expect(error.message).to eq('Only lowercase hexadecimal characters are allowed in private keys.')
    end
  end
end
