# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::InvalidSignatureLengthError do
  describe '#initialize' do
    let(:error) { described_class.new }

    it 'builds a useful error message' do
      expect(error.message).to eq('Invalid signature length. It should have 128 characters.')
    end
  end
end
