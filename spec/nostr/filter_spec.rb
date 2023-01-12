# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Filter do
  let(:filter) do
    described_class.new(
      ids: ['c24881c305c5cfb7c1168be7e9b0e150'],
      authors: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
      kinds: [0, 1, 2],
      since: 1_230_981_305,
      until: 1_292_190_341,
      e: ['7bdb422f254194ae4bb86d354c0bd5a888fce233ffc77dceb3e844ceec1fcfb2'],
      p: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7']
    )
  end

  describe '#==' do
    context 'when both filters have the same attributes' do
      it 'returns true' do
        filter1 = described_class.new(
          ids: ['c24881c305c5cfb7c1168be7e9b0e150'],
          authors: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
          kinds: [0, 1, 2],
          since: 1_230_981_305,
          until: 1_292_190_341,
          e: ['7bdb422f254194ae4bb86d354c0bd5a888fce233ffc77dceb3e844ceec1fcfb2'],
          p: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7']
        )

        filter2 = described_class.new(
          ids: ['c24881c305c5cfb7c1168be7e9b0e150'],
          authors: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
          kinds: [0, 1, 2],
          since: 1_230_981_305,
          until: 1_292_190_341,
          e: ['7bdb422f254194ae4bb86d354c0bd5a888fce233ffc77dceb3e844ceec1fcfb2'],
          p: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7']
        )

        expect(filter1).to eq(filter2)
      end
    end

    context 'when both filters have at least one different attribute' do
      it 'returns false' do
        filter1 = described_class.new(
          ids: ['c24881c305c5cfb7c1168be7e9b0e150'],
          authors: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
          kinds: [0, 1, 2],
          since: 1_230_981_305,
          until: 1_292_190_341,
          e: ['7bdb422f254194ae4bb86d354c0bd5a888fce233ffc77dceb3e844ceec1fcfb2'],
          p: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7']
        )

        filter2 = described_class.new(
          ids: ['c24881c305c5cfb7c1168be7e9b0e150'],
          authors: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
          kinds: [1],
          since: 1_230_981_305,
          until: 1_292_190_341,
          e: ['7bdb422f254194ae4bb86d354c0bd5a888fce233ffc77dceb3e844ceec1fcfb2'],
          p: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7']
        )

        expect(filter1).not_to eq(filter2)
      end
    end
  end

  describe '.new' do
    it 'creates an instance of a filter' do
      filter = described_class.new(
        ids: ['c24881c305c5cfb7c1168be7e9b0e150'],
        authors: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
        kinds: [0, 1, 2],
        since: 1_230_981_305,
        until: 1_292_190_341,
        e: ['7bdb422f254194ae4bb86d354c0bd5a888fce233ffc77dceb3e844ceec1fcfb2'],
        p: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7']
      )

      expect(filter).to be_an_instance_of(described_class)
    end
  end

  describe '#ids' do
    it 'exposes the filter ids' do
      expect(filter.ids).to eq(['c24881c305c5cfb7c1168be7e9b0e150'])
    end
  end

  describe '#authors' do
    it 'exposes the filter authors' do
      expect(filter.authors).to eq(['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'])
    end
  end

  describe '#kinds' do
    it 'exposes the filter kinds' do
      expect(filter.kinds).to eq([0, 1, 2])
    end
  end

  describe '#since' do
    it 'exposes the filter since' do
      expect(filter.since).to eq(1_230_981_305)
    end
  end

  describe '#until' do
    it 'exposes the filter until' do
      expect(filter.until).to eq(1_292_190_341)
    end
  end

  describe '#e' do
    it 'exposes the filter e' do
      expect(filter.e).to eq(['7bdb422f254194ae4bb86d354c0bd5a888fce233ffc77dceb3e844ceec1fcfb2'])
    end
  end

  describe '#p' do
    it 'exposes the filter p' do
      expect(filter.p).to eq(['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'])
    end
  end

  describe '#to_h' do
    it 'converts the filter to a hash' do
      expect(filter.to_h).to eq(
        ids: ['c24881c305c5cfb7c1168be7e9b0e150'],
        authors: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
        kinds: [0, 1, 2],
        '#e': ['7bdb422f254194ae4bb86d354c0bd5a888fce233ffc77dceb3e844ceec1fcfb2'],
        '#p': ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
        since: 1_230_981_305,
        until: 1_292_190_341
      )
    end
  end
end
