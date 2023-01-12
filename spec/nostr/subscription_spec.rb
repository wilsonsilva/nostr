# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Subscription do
  let(:filter) do
    Nostr::Filter.new(since: 1_230_981_305)
  end

  let(:subscription) do
    described_class.new(id: 'c24881c305c5cfb7c1168be7e9b0e150', filter:)
  end

  describe '#==' do
    context 'when both subscriptions have the same attributes' do
      it 'returns true' do
        subscription1 = described_class.new(id: 'c24881c305c5cfb7c1168be7e9b0e150', filter:)
        subscription2 = described_class.new(id: 'c24881c305c5cfb7c1168be7e9b0e150', filter:)

        expect(subscription1).to eq(subscription2)
      end
    end

    context 'when both subscriptions have a different id' do
      it 'returns false' do
        subscription1 = described_class.new(id: 'c24881c305c5cfb7c1168be7e9b0e150', filter:)
        subscription2 = described_class.new(id: '16605b59b539f6e86762f28fb57db2fd', filter:)

        expect(subscription1).not_to eq(subscription2)
      end
    end

    context 'when both subscriptions have a different filter' do
      let(:other_filter) do
        Nostr::Filter.new(since: 1_230_981_305, until: 1_292_190_341)
      end

      it 'returns false' do
        subscription1 = described_class.new(id: 'c24881c305c5cfb7c1168be7e9b0e150', filter:)
        subscription2 = described_class.new(id: 'c24881c305c5cfb7c1168be7e9b0e150', filter: other_filter)

        expect(subscription1).not_to eq(subscription2)
      end
    end
  end

  describe '.new' do
    context 'when no id is provided' do
      it 'creates an instance of a subscription using a randomly generated id' do
        allow(SecureRandom).to receive(:hex).and_return('a_random_string')

        subscription = described_class.new(filter:)

        expect(subscription.id).to eq('a_random_string')
      end
    end

    context 'when an id is provided' do
      it 'creates an instance of a subscription using that ID' do
        subscription = described_class.new(
          id: 'c24881c305c5cfb7c1168be7e9b0e150',
          filter:
        )

        expect(subscription.id).to eq('c24881c305c5cfb7c1168be7e9b0e150')
      end
    end
  end

  describe '#filter' do
    it 'exposes the subscription filter' do
      expect(subscription.filter).to eq(filter)
    end
  end

  describe '#id' do
    it 'exposes the subscription id' do
      expect(subscription.id).to eq('c24881c305c5cfb7c1168be7e9b0e150')
    end
  end
end
