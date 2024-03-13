# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::User do
  let(:keypair) do
    Nostr::KeyPair.new(
      private_key: Nostr::PrivateKey.new('893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900'),
      public_key: Nostr::PublicKey.new('2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558')
    )
  end

  let(:user) do
    described_class.new(keypair:)
  end

  describe '.new' do
    context 'when no key pair is provided' do
      let(:nostr_keygen) do
        instance_double(Nostr::Keygen, generate_key_pair: keypair)
      end

      it 'creates an instance of a user with a new key pair' do
        allow(Nostr::Keygen).to receive(:new).and_return(nostr_keygen)

        user = described_class.new

        aggregate_failures do
          expect(user).to be_an_instance_of(described_class)
          expect(user.keypair).to eq(keypair)
        end
      end
    end

    context 'when a key pair is provided' do
      it 'creates an instance of a user using the provided key pair' do
        user = described_class.new(keypair:)

        expect(user.keypair).to eq(keypair)
      end
    end
  end

  describe '#keypair' do
    it 'exposes the user key pair' do
      expect(user.keypair).to eq(keypair)
    end
  end

  describe '#create_event' do
    context 'when created_at is missing' do
      let(:now) { instance_double(Time, to_i: 1_230_981_305) }

      before { allow(Time).to receive(:now).and_return(now) }

      it 'builds and signs an event using the user key pair and the current time' do
        event = user.create_event(
          kind: Nostr::EventKind::TEXT_NOTE,
          tags: [%w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]],
          content: 'Your feedback is appreciated, now pay $8'
        )

        expect(event).to eq(
          Nostr::Event.new(
            id: '2a3184512d34077601e992ba3c3215354b21a8c76f85c2c7f66093481854e811',
            pubkey: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558',
            created_at: 1_230_981_305,
            kind: 1,
            tags: [%w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]],
            content: 'Your feedback is appreciated, now pay $8',
            sig: '6e852020d5c70527674a21ab7d47db3c355cdbac443a80f5fe2b956f536b75b1' \
                 '3fdfb28a2ffc09cb2438a61b020aaa62e8df7bb08471ccf7839a48350e485937'
          )
        )
      end
    end

    context 'when tags is missing' do
      it 'builds and signs an event using the user key pair and empty tags' do
        event = user.create_event(
          kind: Nostr::EventKind::TEXT_NOTE,
          tags: [],
          created_at: 1_230_981_305,
          content: 'Your feedback is appreciated, now pay $8'
        )

        expect(event).to eq(
          Nostr::Event.new(
            id: 'ed35331e66dc166109d45daff39b8c1bf83d4c0c7a59a9a8a23b240dc126d526',
            pubkey: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558',
            created_at: 1_230_981_305,
            kind: 1,
            tags: [],
            content: 'Your feedback is appreciated, now pay $8',
            sig: '48256fea31f2cabf0e92b5f67c2f654c9647be15b8bc6f381673af3748e15c76' \
                 'b8d505019fc4e75d79be668c18f57b69b76d95b639cca8ae9a5817d569a8d12b'
          )
        )
      end
    end

    context 'when all attributes are present' do
      it 'builds and signs an event using the user key pair' do
        event = user.create_event(
          created_at: 1_230_981_305,
          kind: Nostr::EventKind::TEXT_NOTE,
          tags: [%w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]],
          content: 'Your feedback is appreciated, now pay $8'
        )

        expect(event).to eq(
          Nostr::Event.new(
            id: '2a3184512d34077601e992ba3c3215354b21a8c76f85c2c7f66093481854e811',
            pubkey: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558',
            created_at: 1_230_981_305,
            kind: 1,
            tags: [%w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]],
            content: 'Your feedback is appreciated, now pay $8',
            sig: '6e852020d5c70527674a21ab7d47db3c355cdbac443a80f5fe2b956f536b75b1' \
                 '3fdfb28a2ffc09cb2438a61b020aaa62e8df7bb08471ccf7839a48350e485937'
          )
        )
      end
    end
  end
end
