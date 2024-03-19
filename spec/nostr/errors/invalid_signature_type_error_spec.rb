# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::InvalidSignatureTypeError do
  describe '#initialize' do
    let(:error) { described_class.new }

    it 'builds a useful error message' do
      expect(error.message).to eq('Invalid signature type. It must be a string with lowercase hexadecimal characters.')
    end
  end
end
