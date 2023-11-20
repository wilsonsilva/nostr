# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Key do
  let(:subclass) do
    Class.new(Nostr::Key) do
      def self.hrp
        'npub'
      end

      protected

      def validate_hex_value(_hex_value) = nil
    end
  end

  let(:valid_hex) { 'a' * 64 }

  describe '.new' do
    it 'raises an error because this is an abstract class' do
      expect { described_class.new(valid_hex) }.to raise_error(/Subclasses must implement this method/)
    end
  end

  describe '.from_bech32' do
    context 'when given a valid Bech32 value' do
      let(:valid_bech32) { 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg' }

      it 'creates a new key' do
        expect { subclass.from_bech32(valid_bech32) }.not_to raise_error
      end
    end

    context 'when given an invalid Bech32 value' do
      let(:invalid_bech32) { 'this is obviously not valid' }

      it 'raises an error' do
        expect { subclass.from_bech32(invalid_bech32) }.to raise_error(ArgumentError, /Invalid nip19 string\./)
      end
    end
  end

  describe '.hrp' do
    context 'when called on the abstract class' do
      it 'raises an error because this is an abstract method' do
        expect { described_class.hrp }.to raise_error(/Subclasses must implement this method/)
      end
    end

    context 'when called on a subclass' do
      it 'returns the human readable part of a Bech32 string' do
        expect(subclass.hrp).to eq('npub')
      end
    end
  end

  describe '#to_bech32' do
    let(:key) { subclass.new(valid_hex) }

    it 'returns a bech32 string representation of the key' do
      expect(key.to_bech32).to match(/^npub[0-9a-z]+$/)
    end
  end

  describe '#validate_hex_value' do
    let(:invalid_hex) { 'g' * 64 }

    it 'raises an error because this is an abstract method' do
      expect { described_class.new(invalid_hex) }.to raise_error(/Subclasses must implement this method/)
    end
  end
end
