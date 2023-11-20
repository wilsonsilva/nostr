# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::InvalidHRPError do
  describe '#initialize' do
    let(:given_hrp) { 'nwrong' }
    let(:allowed_hrp) { 'nsec' }
    let(:error) { described_class.new(given_hrp, allowed_hrp) }

    it 'builds a useful error message' do
      expect(error.message).to eq("Invalid hrp: nwrong. The allowed hrp value for this kind of entity is 'nsec'.")
    end
  end
end
