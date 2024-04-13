# frozen_string_literal: true

require 'spec_helper'
require 'nostr/client/plain_logger'

RSpec.describe Nostr::Client::PlainLogger do
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
    it 'logs connection to a relay' do
      expect do
        logger.on_connect(relay)
      end.to output("Connected to the relay localhost (ws://0.0.0.0:4180/)\n").to_stdout
    end
  end

  describe '#on_message' do
    it 'logs a message received from the relay' do
      message = 'Received message'
      expect { logger.on_message(message) }.to output("◄- #{message}\n").to_stdout
    end
  end

  describe '#on_send' do
    it 'logs a message sent to the relay' do
      message = 'Sent message'
      expect { logger.on_send(message) }.to output("-► #{message}\n").to_stdout
    end
  end

  describe '#on_error' do
    it 'logs an error message' do
      message = 'Error message'
      expect { logger.on_error(message) }.to output("Error: #{message}\n").to_stdout
    end
  end

  describe '#on_close' do
    it 'logs a closure of connection with a relay' do
      code = '1000'
      reason = 'Connection closed'
      expect do
        logger.on_close(code, reason)
      end.to output("Connection closed: #{reason} (##{code})\n").to_stdout
    end
  end
end
