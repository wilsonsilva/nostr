# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Relay do
  let(:relay) do
    described_class.new(url: 'wss://relay.damus.io', name: 'Damus')
  end

  describe '.new' do
    it 'creates an instance of a relay' do
      relay = described_class.new(url: 'wss://relay.damus.io', name: 'Damus')

      expect(relay).to be_an_instance_of(described_class)
    end
  end

  describe '#name' do
    it 'exposes the relay name' do
      expect(relay.name).to eq('Damus')
    end
  end

  describe '#public_key' do
    it 'exposes the relay URL' do
      expect(relay.url).to eq('wss://relay.damus.io')
    end
  end
end
