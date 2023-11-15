# frozen_string_literal: true

require 'spec_helper'
require 'nostr/core_ext/string'

using Nostr::CoreExt::String

RSpec.describe Nostr::CoreExt::String do
  describe '#to_hex' do
    context 'when the string is a valid bech32 npub string' do
      it 'converts the string to hex' do
        bech32 = 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'
        expect(bech32.to_hex).to eq('7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e')
      end
    end

    context 'when the string is a valid bech32 nsec string' do
      it 'converts the string to hex' do
        bech32 = 'nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5'
        expect(bech32.to_hex).to eq('67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa')
      end
    end

    context 'when the string is not a valid bech32 string' do
      it 'raises an ArgumentError' do
        non_bech32 = 'anything-else'
        expect { non_bech32.to_hex }.to raise_error(ArgumentError, /Invalid nip19 string/)
      end
    end
  end

  describe '#to_nsec' do
    context 'when the string is a valid hex private key' do
      it 'converts the hex string to a bech32 string' do
        hex = '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'
        expect(hex.to_nsec).to eq('nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5')
      end
    end
  end

  describe '#to_npub' do
    context 'when the string is a valid hex public key' do
      it 'converts the hex string to a bech32 string' do
        hex = '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
        expect(hex.to_npub).to eq('npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg')
      end
    end
  end
end
