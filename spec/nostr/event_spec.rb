# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Event do
  let(:event) do
    described_class.new(
      id: '20f31a9b2a0ced48a167add9732ccade1dca5e34b44316e37da4af33bc8946a9',
      pubkey: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
      created_at: 1_230_981_305,
      kind: 1,
      tags: [
        %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408],
        %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e]
      ],
      content: 'Your feedback is appreciated, now pay $8',
      sig: '058613f8d34c053294cc28b7f9e1f8f0e80fd1ac94fb20f2da6ca514e7360b39' \
           '63d0086171f842ffebf1f7790ce147b4811a15ef3f59c76ec1324b970cc57ffe'
    )
  end

  describe '#==' do
    context 'when both events have the same attributes' do
      it 'returns true' do
        event1 = described_class.new(
          id: '2a3184512d34077601e992ba3c3215354b21a8c76f85c2c7f66093481854e811',
          pubkey: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558',
          created_at: 1_230_981_305,
          kind: 1,
          tags: [%w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]],
          content: 'Your feedback is appreciated, now pay $8',
          sig: '970fea8d213da86c583804522c45d04e61c18c433704b62f793f187bca82091c' \
               '3884d6207c6511c0966ecf6230082179a49257b03e5a4d2d08da9124a190f1bb'
        )

        event2 = described_class.new(
          id: '2a3184512d34077601e992ba3c3215354b21a8c76f85c2c7f66093481854e811',
          pubkey: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558',
          created_at: 1_230_981_305,
          kind: 1,
          tags: [%w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]],
          content: 'Your feedback is appreciated, now pay $8',
          sig: '970fea8d213da86c583804522c45d04e61c18c433704b62f793f187bca82091c' \
               '3884d6207c6511c0966ecf6230082179a49257b03e5a4d2d08da9124a190f1bb'
        )

        expect(event1).to eq(event2)
      end
    end

    context 'when both events have at least one different attribute' do
      it 'returns false' do
        event1 = described_class.new(
          id: '2a3184512d34077601e992ba3c3215354b21a8c76f85c2c7f66093481854e811',
          pubkey: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558',
          created_at: 1_230_981_305,
          kind: 1,
          tags: [%w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]],
          content: 'Your feedback is appreciated, now pay $8',
          sig: '970fea8d213da86c583804522c45d04e61c18c433704b62f793f187bca82091c' \
               '3884d6207c6511c0966ecf6230082179a49257b03e5a4d2d08da9124a190f1bb'
        )

        event2 = described_class.new(
          id: '2a3184512d34077601e992ba3c3215354b21a8c76f85c2c7f66093481854e811',
          pubkey: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558',
          created_at: 1_230_981_305,
          kind: 1,
          tags: [%w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]],
          content: 'Your feedback is appreciated, now pay $8',
          sig: '058613f8d34c053294cc28b7f9e1f8f0e80fd1ac94fb20f2da6ca514e7360b39' \
               '63d0086171f842ffebf1f7790ce147b4811a15ef3f59c76ec1324b970cc57ffe'
        )

        expect(event1).not_to eq(event2)
      end
    end
  end

  describe '.new' do
    it 'creates an instance of an event' do
      event = described_class.new(
        id: '20f31a9b2a0ced48a167add9732ccade1dca5e34b44316e37da4af33bc8946a9',
        pubkey: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
        created_at: 1_230_981_305,
        kind: 1,
        tags: [
          %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408],
          %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e]
        ],
        content: 'Your feedback is appreciated, now pay $8',
        sig: '058613f8d34c053294cc28b7f9e1f8f0e80fd1ac94fb20f2da6ca514e7360b39' \
             '63d0086171f842ffebf1f7790ce147b4811a15ef3f59c76ec1324b970cc57ffe'
      )

      expect(event).to be_an_instance_of(described_class)
    end
  end

  describe '#add_event_reference' do
    let(:event) do
      described_class.new(
        pubkey: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
        kind: Nostr::EventKind::TEXT_NOTE,
        tags: [
          %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e]
        ],
        content: 'Your feedback is appreciated, now pay $8'
      )
    end

    context 'when the event_id is missing' do

    end

    context 'when the relay_url is missing' do
      it 'appends a reference to an event to the event tags' do
        event.add_event_reference('189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408')

        expect(event.tags).to eq(
          [
            %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e],
            %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]
          ]
        )
      end
    end

    context 'when the marker is missing' do
      it 'appends a reference to an event to the event tags' do
        event.add_event_reference('189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408')

        expect(event.tags).to eq(
          [
            %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e],
            %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]
          ]
        )
      end
    end

    context 'when the event_id, relay_url and marker are present' do
      it 'appends a reference to an event to the event tags' do
        event.add_event_reference('189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408')

        expect(event.tags).to eq(
          [
            %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e],
            %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]
          ]
        )
      end
    end
  end

  describe '#add_pubkey_reference' do
    let(:event) do
      described_class.new(
        pubkey: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
        kind: Nostr::EventKind::TEXT_NOTE,
        tags: [
          %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]
        ],
        content: 'Your feedback is appreciated, now pay $8'
      )
    end

    it 'appends a reference to a pubkey to the event tags' do
      event.add_pubkey_reference('472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e')

      expect(event.tags).to eq(
        [
          %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408],
          %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e]
        ]
      )
    end
  end

  describe '#content' do
    it 'exposes the event content' do
      expect(event.content).to eq('Your feedback is appreciated, now pay $8')
    end
  end

  describe '#created_at' do
    it 'exposes the event creation date' do
      expect(event.created_at).to eq(1_230_981_305)
    end
  end

  describe '#kind' do
    it 'exposes the event kind' do
      expect(event.kind).to eq(1)
    end
  end

  describe '#id' do
    it 'exposes the event id' do
      expect(event.id).to eq('20f31a9b2a0ced48a167add9732ccade1dca5e34b44316e37da4af33bc8946a9')
    end
  end

  describe '#id=' do
    it 'sets the event id' do
      new_id = '20f31a9b2a0ced48a167add9732ccade1dca5e34b44316e37da4af33bc8946a9'

      event.id = new_id
      expect(event.id).to eq(new_id)
    end
  end

  describe '#pubkey' do
    it 'exposes the event pubkey' do
      expect(event.pubkey).to eq('ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460')
    end
  end

  describe '#serialize' do
    it 'serializes the event according to NIP-01' do
      serialized_event = event.serialize

      expect(serialized_event).to eq(
        [
          0,
          'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
          1_230_981_305,
          1,
          [
            %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408],
            %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e]
          ],
          'Your feedback is appreciated, now pay $8'
        ]
      )
    end
  end

  describe '#sig' do
    it 'exposes the event signature' do
      expect(event.sig).to eq(
        '058613f8d34c053294cc28b7f9e1f8f0e80fd1ac94fb20f2da6ca514e7360b39' \
        '63d0086171f842ffebf1f7790ce147b4811a15ef3f59c76ec1324b970cc57ffe'
      )
    end
  end

  describe '#sig=' do
    it 'sets the event signature' do
      new_signature = '058613f8d34c053294cc28b7f9e1f8f0e80fd1ac94fb20f2da6ca514e7360b39' \
                      '63d0086171f842ffebf1f7790ce147b4811a15ef3f59c76ec1324b970cc57ffe'

      event.sig = new_signature
      expect(event.sig).to eq(new_signature)
    end
  end

  describe '#sign' do
    let(:event) do
      described_class.new(
        pubkey: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
        kind: Nostr::EventKind::TEXT_NOTE,
        content: 'Your feedback is appreciated, now pay $8'
      )
    end
    let(:keypair) do
      Nostr::KeyPair.new(
        public_key: '8a9d69c56e3c691bec8f9565e4dcbe38ae1d88fffeec3ce66b9f47558a3aa8ca',
        private_key: '3185a47e3802f956ca5a2b4ea606c1d51c7610f239617e8f0f218d55bdf2b757'
      )
    end

    it 'signs the event' do
      event.sign(keypair.private_key)

      aggregate_failures do
        expect(event.id.length).to eq(64)
        expect(event.sig.length).to eq(128)
      end
    end
  end

  describe '#tags' do
    it 'exposes the event tags' do
      expect(event.tags).to eq(
        [
          %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408],
          %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e]
        ]
      )
    end
  end

  describe '#to_h' do
    it 'converts the event to a hash' do
      expect(event.to_h).to eq(
        id: '20f31a9b2a0ced48a167add9732ccade1dca5e34b44316e37da4af33bc8946a9',
        pubkey: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
        created_at: 1_230_981_305,
        kind: 1,
        tags: [%w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408],
               %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e]],
        content: 'Your feedback is appreciated, now pay $8',
        sig: '058613f8d34c053294cc28b7f9e1f8f0e80fd1ac94fb20f2da6ca514e7360b39' \
             '63d0086171f842ffebf1f7790ce147b4811a15ef3f59c76ec1324b970cc57ffe'
      )
    end
  end
end
