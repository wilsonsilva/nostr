# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::InvalidSignatureTypeError do
  describe '#initialize' do
    let(:error) { described_class.new }

    it 'builds a useful error message' do
      expect(error.message).to eq('Invalid signature type')
    end
  end
end
