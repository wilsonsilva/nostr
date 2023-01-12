# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::KeyPair do
  let(:keypair) do
    described_class.new(
      private_key: '893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900',
      public_key: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558'
    )
  end

  describe '.new' do
    it 'creates an instance of a key pair' do
      keypair = described_class.new(
        private_key: '893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900',
        public_key: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558'
      )

      expect(keypair).to be_an_instance_of(described_class)
    end
  end

  describe '#private_key' do
    it 'exposes the private key' do
      expect(keypair.private_key).to eq('893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900')
    end
  end

  describe '#public_key' do
    it 'exposes the public key' do
      expect(keypair.public_key).to eq('2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558')
    end
  end
end
