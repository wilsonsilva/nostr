# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::InvalidSignatureFormatError do
  describe '#initialize' do
    let(:error) { described_class.new }

    it 'builds a useful error message' do
      expect(error.message).to eq('Only lowercase hexadecimal characters are allowed in signatures.')
    end
  end
end
