# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::EventFragment do
  let(:event_fragment) do
    described_class.new(
      pubkey: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
      created_at: 1_230_981_305,
      kind: 1,
      tags: [
        %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408],
        %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e]
      ],
      content: 'Your feedback is appreciated, now pay $8'
    )
  end

  describe '.new' do
    it 'creates an instance of an event fragment' do
      event_fragment = described_class.new(
        pubkey: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
        created_at: 1_230_981_305,
        kind: 1,
        tags: [
          %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408],
          %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e]
        ],
        content: 'Your feedback is appreciated, now pay $8'
      )

      expect(event_fragment).to be_an_instance_of(described_class)
    end
  end

  describe '#content' do
    it 'exposes the event fragment content' do
      expect(event_fragment.content).to eq('Your feedback is appreciated, now pay $8')
    end
  end

  describe '#created_at' do
    it 'exposes the event fragment creation date' do
      expect(event_fragment.created_at).to eq(1_230_981_305)
    end
  end

  describe '#kind' do
    it 'exposes the event fragment kind' do
      expect(event_fragment.kind).to eq(1)
    end
  end

  describe '#pubkey' do
    it 'exposes the event fragment pubkey' do
      expect(event_fragment.pubkey).to eq('ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460')
    end
  end

  describe '#serialize' do
    it 'serializes the event fragment according to NIP-01' do
      serialized_event_fragment = event_fragment.serialize

      expect(serialized_event_fragment).to eq(
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

  describe '#tags' do
    it 'exposes the event fragment tags' do
      expect(event_fragment.tags).to eq(
        [
          %w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408],
          %w[p 472f440f29ef996e92a186b8d320ff180c855903882e59d50de1b8bd5669301e]
        ]
      )
    end
  end
end
