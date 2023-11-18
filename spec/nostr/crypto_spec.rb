# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Crypto do
  let(:crypto) { described_class.new }

  describe '#sign_event' do
    let(:keypair) do
      Nostr::KeyPair.new(
        public_key: '8a9d69c56e3c691bec8f9565e4dcbe38ae1d88fffeec3ce66b9f47558a3aa8ca',
        private_key: '3185a47e3802f956ca5a2b4ea606c1d51c7610f239617e8f0f218d55bdf2b757'
      )
    end

    let(:event) do
      Nostr::Event.new(
        kind: Nostr::EventKind::TEXT_NOTE,
        content: 'Your feedback is appreciated, now pay $8',
        pubkey: keypair.public_key
      )
    end

    it 'signs an event' do
      signed_event = crypto.sign_event(event, keypair.private_key)

      aggregate_failures do
        expect(signed_event.id.length).to eq(64)
        expect(signed_event.sig.length).to eq(128)
      end
    end
  end

  describe '#encrypt_text' do
    let(:sender_keypair) do
      Nostr::KeyPair.new(
        public_key: '8a9d69c56e3c691bec8f9565e4dcbe38ae1d88fffeec3ce66b9f47558a3aa8ca',
        private_key: '3185a47e3802f956ca5a2b4ea606c1d51c7610f239617e8f0f218d55bdf2b757'
      )
    end

    let(:recipient_keypair) do
      Nostr::KeyPair.new(
        public_key: '6c31422248998e300a1a457167565da7d15d0da96651296ee2791c29c11b6aa0',
        private_key: '22cea01c33eccf30fdd54cb6728f814f6de00c778aafd721e017f4582545f9cf'
      )
    end

    it 'encrypts plain text' do
      encrypted_text = crypto.encrypt_text(sender_keypair.private_key, recipient_keypair.public_key, 'Twitter Files')
      decrypted_text = crypto.decrypt_text(recipient_keypair.private_key, sender_keypair.public_key, encrypted_text)

      expect(decrypted_text).to eq('Twitter Files')
    end
  end

  describe '#descrypt_text' do
    let(:sender_keypair) do
      Nostr::KeyPair.new(
        public_key: '8a9d69c56e3c691bec8f9565e4dcbe38ae1d88fffeec3ce66b9f47558a3aa8ca',
        private_key: '3185a47e3802f956ca5a2b4ea606c1d51c7610f239617e8f0f218d55bdf2b757'
      )
    end

    let(:recipient_keypair) do
      Nostr::KeyPair.new(
        public_key: '6c31422248998e300a1a457167565da7d15d0da96651296ee2791c29c11b6aa0',
        private_key: '22cea01c33eccf30fdd54cb6728f814f6de00c778aafd721e017f4582545f9cf'
      )
    end

    context 'when the encrypted text includes an iv query string' do
      it 'decrypts an encrypted text' do
        encrypted_text = crypto.encrypt_text(sender_keypair.private_key, recipient_keypair.public_key, 'Twitter Files')
        decrypted_text = crypto.decrypt_text(recipient_keypair.private_key, sender_keypair.public_key, encrypted_text)

        expect(decrypted_text).to eq('Twitter Files')
      end
    end

    context 'when the encrypted text does not include an iv query string' do
      it 'returns an empty string' do
        encrypted_text = 'wrYQaHDfpOEvyJELSCg1vzsywmlJTz8NqH03eFW44s8iQs869jtSb26Lr4s23gmY?it=v38vAJ3LlJAGZxbmWU4qAg=='
        decrypted_text = crypto.decrypt_text(recipient_keypair.private_key, sender_keypair.public_key, encrypted_text)

        expect(decrypted_text).to eq('')
      end
    end
  end
end
