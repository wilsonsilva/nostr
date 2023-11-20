# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::PrivateKey do
  let(:valid_hex) { '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa' }
  let(:private_key) { described_class.new(valid_hex) }

  describe '.new' do
    context 'when the private key is not a string' do
      it 'raises an InvalidKeyTypeError' do
        expect { described_class.new(1234) }.to raise_error(
          Nostr::InvalidKeyTypeError,
          'Invalid private key type'
        )
      end
    end

    context "when the private key's length is not 64 characters" do
      it 'raises an InvalidKeyLengthError' do
        expect { described_class.new('a' * 65) }.to raise_error(
          Nostr::InvalidKeyLengthError,
          'Invalid private key length. It should have 64 characters.'
        )
      end
    end

    context 'when the private key contains non-hexadecimal characters' do
      it 'raises an InvalidKeyFormatError' do
        expect { described_class.new('g' * 64) }.to raise_error(
          Nostr::InvalidKeyFormatError,
          'Only lowercase hexadecimal characters are allowed in private keys.'
        )
      end
    end

    context 'when the private key contains uppercase characters' do
      it 'raises an InvalidKeyFormatError' do
        expect { described_class.new('A' * 64) }.to raise_error(
          Nostr::InvalidKeyFormatError,
          'Only lowercase hexadecimal characters are allowed in private keys.'
        )
      end
    end

    context 'when the private key is valid' do
      it 'does not raise any error' do
        expect { described_class.new('a' * 64) }.not_to raise_error
      end
    end
  end

  describe '.from_bech32' do
    context 'when given a valid Bech32 value' do
      let(:valid_bech32) { 'nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5' }

      it 'instantiates a private key from a Bech32 encoded string' do
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
      expect(described_class.hrp).to eq('nsec')
    end
  end

  describe '#to_bech32' do
    it 'converts the hex key to bech32' do
      expect(private_key.to_bech32).to eq('nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5')
    end
  end
end
