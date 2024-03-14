# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Crypto do
  let(:crypto) { described_class.new }

  describe '#check_sig!' do
    let(:keypair) do
      Nostr::KeyPair.new(
        public_key: Nostr::PublicKey.new('15678d8fbc126fa326fac536acd5a6dcb5ef64b3d939abe31d6830cba6cd26d6'),
        private_key: Nostr::PrivateKey.new('7d1e4219a5e7d8342654c675085bfbdee143f0eb0f0921f5541ef1705a2b407d')
      )
    end
    let(:message) { 'Your feedback is appreciated, now pay $8' }

    context 'when the signature is valid' do
      it 'returns true' do
        signature = crypto.sign_message(message, keypair.private_key)

        expect(crypto.check_sig!(message, keypair.public_key, signature)).to be(true)
      end
    end

    context 'when the signature is invalid' do
      it 'raises an error' do
        signature = Nostr::Signature.new('badbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadb' \
                                         'badbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadb')

        expect do
          crypto.check_sig!(message, keypair.public_key, signature)
        end.to raise_error(Schnorr::InvalidSignatureError, 'signature verification failed.')
      end
    end
  end

  describe '#valid_sig?' do
    let(:keypair) do
      Nostr::KeyPair.new(
        public_key: Nostr::PublicKey.new('15678d8fbc126fa326fac536acd5a6dcb5ef64b3d939abe31d6830cba6cd26d6'),
        private_key: Nostr::PrivateKey.new('7d1e4219a5e7d8342654c675085bfbdee143f0eb0f0921f5541ef1705a2b407d')
      )
    end
    let(:message) { 'Your feedback is appreciated, now pay $8' }

    context 'when the signature is valid' do
      it 'returns true' do
        signature = crypto.sign_message(message, keypair.private_key)

        expect(crypto.valid_sig?(message, keypair.public_key, signature)).to be(true)
      end
    end

    context 'when the signature is invalid' do
      it 'returns false' do
        signature = Nostr::Signature.new('badbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadb' \
                                         'badbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadb')

        expect(crypto.valid_sig?(message, keypair.public_key, signature)).to be(false)
      end
    end
  end

  describe '#sign_event' do
    let(:keypair) do
      Nostr::KeyPair.new(
        public_key: Nostr::PublicKey.new('8a9d69c56e3c691bec8f9565e4dcbe38ae1d88fffeec3ce66b9f47558a3aa8ca'),
        private_key: Nostr::PrivateKey.new('3185a47e3802f956ca5a2b4ea606c1d51c7610f239617e8f0f218d55bdf2b757')
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

  describe '#sign_message' do
    let(:private_key) { Nostr::PrivateKey.new('7d1e4219a5e7d8342654c675085bfbdee143f0eb0f0921f5541ef1705a2b407d') }
    let(:message) { 'Your feedback is appreciated, now pay $8' }

    it 'signs a message' do
      signature = crypto.sign_message(message, private_key)
      hex_signature = '0fa6d8e26f44ddad9eca5be2b8a25d09338c1767f8bfce384046c8eb771d1120e4bda5ca49' \
                      '27e74837f912d4810945af6abf8d38139c1347f2d71ba8c52b175b'

      expect(signature).to eq(Nostr::Signature.new(hex_signature))
    end
  end

  describe '#encrypt_text' do
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

    it 'encrypts plain text' do
      encrypted_text = crypto.encrypt_text(sender_keypair.private_key, recipient_keypair.public_key, 'Twitter Files')
      decrypted_text = crypto.decrypt_text(recipient_keypair.private_key, sender_keypair.public_key, encrypted_text)

      expect(decrypted_text).to eq('Twitter Files')
    end
  end

  describe '#descrypt_text' do
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
