# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Events::EncryptedDirectMessage do
  describe '.new' do
    let(:sender_keypair) do
      Nostr::KeyPair.new(
        public_key: Nostr::PublicKey.new('8a9d69c56e3c691bec8f9565e4dcbe38ae1d88fffeec3ce66b9f47558a3aa8ca'),
        private_key: Nostr::PrivateKey.new('3185a47e3802f956ca5a2b4ea606c1d51c7610f239617e8f0f218d55bdf2b757')
      )
    end

    let(:recipient_keypair) do
      Nostr::KeyPair.new(
        public_key: Nostr::PublicKey.new('6c31422248998e300a1a457167565da7d15d0da96651296ee2791c29c11b6aa0'),
        private_key: Nostr::PrivateKey.new('22cea01c33eccf30fdd54cb6728f814f6de00c778aafd721e017f4582545f9cf')
      )
    end

    let(:crypto) { Nostr::Crypto.new }

    it 'creates an instance of an encrypted private message event that can be decrypted by its recipient' do
      encrypted_direct_message = described_class.new(
        sender_private_key: sender_keypair.private_key,
        recipient_public_key: recipient_keypair.public_key,
        plain_text: 'Your feedback is appreciated, now pay $8'
      )

      plain_text = crypto.decrypt_text(
        recipient_keypair.private_key,
        sender_keypair.public_key,
        encrypted_direct_message.content
      )

      aggregate_failures do
        expect(encrypted_direct_message.content).not_to eq(plain_text)
        expect(plain_text).to eq('Your feedback is appreciated, now pay $8')
      end
    end

    it 'adds a reference to the recipient in the tags' do
      encrypted_direct_message = described_class.new(
        sender_private_key: sender_keypair.private_key,
        recipient_public_key: recipient_keypair.public_key,
        plain_text: 'Your feedback is appreciated, now pay $8'
      )

      expect(encrypted_direct_message.tags).to eq([['p', recipient_keypair.public_key]])
    end

    context 'when previous_direct_message is omitted' do
      it 'does not add a reference to a previous message' do
        encrypted_direct_message = described_class.new(
          sender_private_key: sender_keypair.private_key,
          recipient_public_key: recipient_keypair.public_key,
          plain_text: 'Your feedback is appreciated, now pay $8'
        )

        expect(encrypted_direct_message.tags).to eq([['p', recipient_keypair.public_key]])
      end
    end

    context 'when previous_direct_message is given' do
      let(:previous_direct_message_id) { 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460' }

      it 'adds a reference to a previous message' do
        encrypted_direct_message = described_class.new(
          sender_private_key: sender_keypair.private_key,
          recipient_public_key: recipient_keypair.public_key,
          plain_text: 'Your feedback is appreciated, now pay $8',
          previous_direct_message: previous_direct_message_id
        )

        expect(encrypted_direct_message.tags).to eq(
          [
            ['p', recipient_keypair.public_key],
            ['e', previous_direct_message_id]
          ]
        )
      end
    end
  end
end
