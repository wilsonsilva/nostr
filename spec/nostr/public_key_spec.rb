# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::PublicKey do
  let(:valid_hex) { '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e' }
  let(:public_key) { described_class.new(valid_hex) }

  describe '.new' do
    context 'when the public key is not a string' do
      it 'raises an InvalidPublicKeyTypeError' do
        expect { described_class.new(1234) }.to raise_error(
          Nostr::InvalidPublicKeyTypeError,
          'Invalid public key type'
        )
      end
    end

    context "when the public key's length is not 64 characters" do
      it 'raises an InvalidPublicKeyLengthError' do
        expect { described_class.new('a' * 65) }.to raise_error(
          Nostr::InvalidPublicKeyLengthError,
          'Invalid public key length. It should have 64 characters.'
        )
      end
    end

    context 'when the public key contains non-hexadecimal characters' do
      it 'raises an InvalidPublicKeyFormatError' do
        expect { described_class.new('g' * 64) }.to raise_error(
          Nostr::InvalidPublicKeyFormatError,
          'Only lowercase hexadecimal characters are allowed.'
        )
      end
    end

    context 'when the public key contains uppercase characters' do
      it 'raises an InvalidPublicKeyFormatError' do
        expect { described_class.new('A' * 64) }.to raise_error(
          Nostr::InvalidPublicKeyFormatError,
          'Only lowercase hexadecimal characters are allowed.'
        )
      end
    end

    context 'when the public key is valid' do
      it 'does not raise any error' do
        expect { described_class.new('a' * 64) }.not_to raise_error
      end
    end
  end

  describe '.from_bech32' do
    context 'when given a valid Bech32 value' do
      let(:valid_bech32) { 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg' }

      it 'instantiates a public key from a Bech32 encoded string' do
        expect(described_class.from_bech32(valid_bech32)).to eq(valid_hex)
      end
    end

    context 'when given an invalid Bech32 value' do
      let(:invalid_bech32) { 'this is obviously not valid' }

      it 'raises an error' do
        expect { described_class.from_bech32(invalid_bech32) }.to raise_error(ArgumentError, /Invalid nip19 string\./)
      end
    end
  end

  describe '.hrp' do
    it 'returns the human readable part of a Bech32 string' do
      expect(described_class.hrp).to eq('npub')
    end
  end

  describe '#to_bech32' do
    it 'converts the hex key to bech32' do
      expect(public_key.to_bech32).to eq('npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg')
    end
  end
end
