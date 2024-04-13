# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Client::Logger do
  let(:client) { instance_spy(Nostr::Client) }
  let(:relay) { Nostr::Relay.new(url: 'ws://0.0.0.0:4180/', name: 'localhost') }
  let(:logger) { described_class.new }

  describe '#attach_to' do
    it 'attaches event handlers to the client' do
      logger.attach_to(client)

      aggregate_failures do
        expect(client).to have_received(:on).with(:connect)
        expect(client).to have_received(:on).with(:message)
        expect(client).to have_received(:on).with(:send)
        expect(client).to have_received(:on).with(:error)
        expect(client).to have_received(:on).with(:close)
      end
    end
  end

  describe '#on_connect' do
    it 'returns nil' do
      expect(logger.on_connect(relay)).to be_nil
    end
  end

  describe '#on_message' do
    it 'returns nil' do
      message = 'Received message'
      expect(logger.on_message(message)).to be_nil
    end
  end

  describe '#on_send' do
    it 'returns nil' do
      message = 'Sent message'
      expect(logger.on_send(message)).to be_nil
    end
  end

  describe '#on_error' do
    it 'returns nil' do
      message = 'Error message'
      expect(logger.on_error(message)).to be_nil
    end
  end

  describe '#on_close' do
    it 'returns nil' do
      code = 1000
      reason = 'Normal closure'
      expect(logger.on_close(code, reason)).to be_nil
    end
  end
end
