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
end
