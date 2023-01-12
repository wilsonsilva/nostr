# frozen_string_literal: true

require 'spec_helper'

# This test suite does not use let blocks because they don't work with EventMachine.
#
# EventMachine is a pain to work with, hence the use of sleep statements and instance variables.
# I'll come back to fix this once I'm more familiar with it.

RSpec.describe Nostr::Client do
  def server(port)
    @echo_server = EchoServer.new
    @echo_server.listen(port)
  end

  def stop
    @echo_server.stop
  end

  let(:client) { described_class.new }
  let(:relay)  { Nostr::Relay.new(url: plain_text_url, name: 'localhost') }

  let(:port)           { 4180 }
  let(:plain_text_url) { "ws://0.0.0.0:#{port}/" }

  before { server port }
  after  { stop }

  describe '.new' do
    it 'creates an instance of a relay' do
      client = described_class.new

      expect(client).to be_an_instance_of(described_class)
    end
  end

  describe '#connect' do
    it 'connects to the relay' do
      connected = false

      client.on :connect do
        connected = true
      end

      client.connect(relay)
      sleep 0.02

      expect(connected).to be(true)
    end
  end

  describe '#on' do
    context 'when the connection is opened' do
      it 'fires the :connect event' do
        connect_event_fired = false

        client.on :connect do
          connect_event_fired = true
        end

        client.connect(relay)
        sleep 0.02

        expect(connect_event_fired).to be(true)
      end
    end

    context 'when the client receives a message' do
      it 'fires the :message event' do
        received_message = nil

        client.on :message do |_message|
          received_message = 'hello'
        end

        client.connect(relay)

        sleep 0.1

        @echo_server.send('hello')

        sleep 0.1

        expect(received_message).to eq('hello')
      end
    end

    context "when there's a connection error" do
      it 'fires the :error event' do
        connection_error_event = nil

        client.on :error do |event|
          connection_error_event = event
        end

        relay = Nostr::Relay.new(url: 'musk', name: 'localhost')

        client.connect(relay)

        sleep 0.1

        expect(connection_error_event).to eq('Network error: musk: musk is not a valid WebSocket URL')
      end
    end

    context 'when the connection is closed' do
      it 'fires the :close event' do
        connection_closed_code = nil
        connection_closed_reason = nil

        client.on :close do |code, reason|
          connection_closed_code = code
          connection_closed_reason = reason
        end

        client.connect(relay)

        sleep 0.1

        @echo_server.close(1000, 'We are done')

        sleep 0.1

        aggregate_failures do
          expect(connection_closed_code).to eq(1000)
          expect(connection_closed_reason).to eq('We are done')
        end
      end
    end
  end

  describe '#subscribe' do
    context 'when given a subscription id' do
      it 'sends a REQ message to the relay, asking for all events and returns a subscription with the same id' do
        id = '16605b59b539f6e86762f28fb57db2fd'

        client = described_class.new

        sent_message = nil
        subscription = nil

        client.on :message do |message|
          sent_message = message
        end

        client.on :connect do
          subscription = client.subscribe(subscription_id: id)
        end

        relay = Nostr::Relay.new(url: plain_text_url, name: 'localhost')
        client.connect(relay)

        sleep 0.01

        aggregate_failures do
          expect(sent_message).to eq('["REQ","16605b59b539f6e86762f28fb57db2fd",{}]')
          expect(subscription).to eq(Nostr::Subscription.new(id:, filter: nil))
        end
      end
    end

    context 'when given a filter' do
      it 'sends a REQ message to the relay, asking for filtered events and returns a subscription with same filter' do
        allow(SecureRandom).to receive(:hex).and_return('16605b59b539f6e86762f28fb57db2fd')
        filter = Nostr::Filter.new(since: 1_230_981_305)

        client = described_class.new

        sent_message = nil
        subscription = nil

        client.on :message do |message|
          sent_message = message
        end

        client.on :connect do
          subscription = client.subscribe(filter:)
        end

        relay = Nostr::Relay.new(url: plain_text_url, name: 'localhost')
        client.connect(relay)

        sleep 0.01

        aggregate_failures do
          expect(sent_message).to eq('["REQ","16605b59b539f6e86762f28fb57db2fd",{"since":1230981305}]')
          expect(subscription).to eq(Nostr::Subscription.new(id: '16605b59b539f6e86762f28fb57db2fd', filter:))
        end
      end
    end

    context 'when given a subscription id and a filter' do
      it 'sends a REQ message to the relay, asking for filtered events and returns a subscription with the same id' do
        id = '16605b59b539f6e86762f28fb57db2fd'
        filter = Nostr::Filter.new(since: 1_230_981_305)

        client = described_class.new

        sent_message = nil
        subscription = nil

        client.on :message do |message|
          sent_message = message
        end

        client.on :connect do
          subscription = client.subscribe(subscription_id: id, filter:)
        end

        relay = Nostr::Relay.new(url: plain_text_url, name: 'localhost')
        client.connect(relay)

        sleep 0.01

        aggregate_failures do
          expect(sent_message).to eq('["REQ","16605b59b539f6e86762f28fb57db2fd",{"since":1230981305}]')
          expect(subscription).to eq(Nostr::Subscription.new(id:, filter:))
        end
      end
    end

    context 'when not given a subscription id nor a filter' do
      it 'sends a REQ message to the relay, asking for all events and returns a subscription with a random id' do
        allow(SecureRandom).to receive(:hex).and_return('16605b59b539f6e86762f28fb57db2fd')

        client = described_class.new

        sent_message = nil
        subscription = nil

        client.on :message do |message|
          sent_message = message
        end

        client.on :connect do
          subscription = client.subscribe
        end

        relay = Nostr::Relay.new(url: plain_text_url, name: 'localhost')
        client.connect(relay)

        sleep 0.01

        aggregate_failures do
          expect(sent_message).to eq('["REQ","16605b59b539f6e86762f28fb57db2fd",{}]')
          expect(subscription).to eq(Nostr::Subscription.new(id: '16605b59b539f6e86762f28fb57db2fd', filter: nil))
        end
      end
    end
  end

  describe '#unsubscribe' do
    it 'sends a CLOSE message to the relay, asking it to stop a subscription' do
      subscription_id = '16605b59b539f6e86762f28fb57db2fd'

      client = described_class.new

      sent_message = nil

      client.on :message do |message|
        sent_message = message
      end

      client.on :connect do
        client.unsubscribe(subscription_id:)
      end

      relay = Nostr::Relay.new(url: plain_text_url, name: 'localhost')
      client.connect(relay)

      sleep 0.01

      expect(sent_message).to eq(['CLOSE', { subscription_id: }].to_json)
    end
  end

  describe '#publish' do
    it 'sends a message to the relay' do
      relay = Nostr::Relay.new(url: plain_text_url, name: 'localhost')
      client = described_class.new
      event = Nostr::Event.new(
        id: '2a3184512d34077601e992ba3c3215354b21a8c76f85c2c7f66093481854e811',
        pubkey: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558',
        created_at: 1_230_981_305,
        kind: 1,
        tags: [%w[e 189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408]],
        content: 'Your feedback is appreciated, now pay $8',
        sig: '970fea8d213da86c583804522c45d04e61c18c433704b62f793f187bca82091c' \
             '3884d6207c6511c0966ecf6230082179a49257b03e5a4d2d08da9124a190f1bb'
      )

      received_message = nil

      client.on :message do |message|
        received_message = message
      end

      client.on :connect do
        client.publish(event)
      end

      client.connect(relay)

      sleep 0.01

      expect(received_message).to eq(['EVENT', event.to_h].to_json)
    end
  end
end
