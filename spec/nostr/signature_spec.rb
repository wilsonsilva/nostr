# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Signature do
  let(:valid_hex_signature) do
    'f418c97b50cc68227e82f4f3a79d79eb2b7a0fa517859c86e1a8fa91e3741b7f' \
      '06e070c44129227b83fcbe93cecb02a346804a4080ce47685ecad60ab4f5f128'
  end

  let(:signature) { described_class.new(valid_hex_signature) }

  describe '.new' do
    context 'when the signature is not a string' do
      it 'raises an InvalidSignatureTypeError' do
        expect { described_class.new(1234) }.to raise_error(
          Nostr::InvalidSignatureTypeError,
          'Invalid signature type'
        )
      end
    end

    context "when the signature's length is not 128 characters" do
      it 'raises an InvalidSignatureLengthError' do
        expect { described_class.new('a' * 129) }.to raise_error(
          Nostr::InvalidSignatureLengthError,
          'Invalid signature length. It should have 128 characters.'
        )
      end
    end

    context 'when the signature contains non-hexadecimal characters' do
      it 'raises an InvalidKeyFormatError' do
        expect { described_class.new('g' * 128) }.to raise_error(
          Nostr::InvalidSignatureFormatError,
          'Only lowercase hexadecimal characters are allowed in signatures.'
        )
      end
    end

    context 'when the signature contains uppercase characters' do
      it 'raises an InvalidKeyFormatError' do
        expect { described_class.new('A' * 128) }.to raise_error(
          Nostr::InvalidSignatureFormatError,
          'Only lowercase hexadecimal characters are allowed in signatures.'
        )
      end
    end

    context 'when the signature is valid' do
      it 'does not raise any error' do
        expect { described_class.new('a' * 128) }.not_to raise_error
      end
    end
  end
end
