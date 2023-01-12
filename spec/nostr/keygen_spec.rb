# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Keygen do
  let(:keygen) { described_class.new }

  describe '.new' do
    it 'creates an instance of a keygen' do
      keygen = described_class.new

      expect(keygen).to be_an_instance_of(described_class)
    end
  end

  describe '#generate_key_pair' do
    it 'generates a private/public key pair' do
      keypair = keygen.generate_key_pair

      aggregate_failures do
        expect(keypair.private_key).to match(/[a-f0-9]{64}/)
        expect(keypair.public_key).to match(/[a-f0-9]{64}/)
      end
    end
  end

  describe '#generate_private_key' do
    it 'generates a private key' do
      private_key = keygen.generate_private_key

      expect(private_key).to match(/[a-f0-9]{64}/)
    end
  end

  describe '#extract_public_key' do
    it 'extracts a public key from a private key' do
      private_key = '893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900'
      public_key = keygen.extract_public_key(private_key)

      expect(public_key).to eq('2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558')
    end
  end
end
