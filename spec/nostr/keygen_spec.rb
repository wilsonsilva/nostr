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

  describe '.get_key_pair_from_private_key' do
    context 'when given a private key' do
      let(:private_key) { Nostr::PrivateKey.new('893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900') }

      it 'generates a key pair' do
        keypair = keygen.get_key_pair_from_private_key(private_key)

        aggregate_failures do
          expect(keypair.private_key).to be_an_instance_of(Nostr::PrivateKey)
          expect(keypair.public_key).to be_an_instance_of(Nostr::PublicKey)
        end
      end
    end

    context 'when given another kind of value' do
      let(:not_a_private_key) { 'something else' }

      it 'raises an error' do
        expect { keygen.get_key_pair_from_private_key(not_a_private_key) }.to raise_error(
          ArgumentError, 'private_key is not an instance of PrivateKey'
        )
      end
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
    context 'when the given value is not a private key' do
      let(:not_a_private_key) { 'something else' }

      it 'raises an error' do
        expect { keygen.extract_public_key(not_a_private_key) }.to raise_error(
          ArgumentError, 'private_key is not an instance of PrivateKey'
        )
      end
    end

    context 'when the given value is a private key' do
      let(:private_key) { Nostr::PrivateKey.new('893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900') }

      it 'extracts a public key from a private key' do
        public_key = keygen.extract_public_key(private_key)

        expect(public_key).to eq('2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558')
      end
    end
  end
end
