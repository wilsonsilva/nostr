# frozen_string_literal: true

require 'event_emitter'
require 'faye/websocket'

module Nostr
  # Clients can talk with relays and can subscribe to any set of events using a subscription filters.
  # The filter represents all the set of nostr events that a client is interested in.
  #
  # There is no sign-up or account creation for a client. Every time a client connects to a relay, it submits its
  # subscription filters and the relay streams the "interested events" to the client as long as they are connected.
  #
  class Client
    include EventEmitter

    # Instantiates a new Client
    #
    # @api public
    #
    # @example Instantiating a client that logs all the events it sends and receives
    #   client = Nostr::Client.new(debug: true)
    #
    def initialize
      @subscriptions = {}

      initialize_channels
    end

    # Connects to the Relay's websocket endpoint
    #
    # @api public
    #
    # @example Connecting to a relay
    #   relay = Nostr::Relay.new(url: 'wss://relay.damus.io', name: 'Damus')
    #   client.connect(relay)
    #
    # @param [Relay] relay The relay to connect to
    #
    # @return [void]
    #
    def connect(relay)
      execute_within_an_em_thread do
        client = Faye::WebSocket::Client.new(relay.url, [], { tls: { verify_peer: false } })
        parent_to_child_channel.subscribe { |msg| client.send(msg) }

        client.on :open do
          child_to_parent_channel.push(type: :open)
        end

        client.on :message do |event|
          child_to_parent_channel.push(type: :message, data: event.data)
        end

        client.on :error do |event|
          child_to_parent_channel.push(type: :error, message: event.message)
        end

        client.on :close do |event|
          child_to_parent_channel.push(type: :close, code: event.code, reason: event.reason)
        end
      end
    end

    # Subscribes to a set of events using a filter
    #
    # @api public
    #
    # @example Creating a subscription with no id and no filters
    #   subscription = client.subscribe
    #
    # @example Creating a subscription with an ID
    #   subscription = client.subscribe(subscription_id: 'my-subscription')
    #
    # @example Subscribing to all events created after a certain time
    #   subscription = client.subscribe(filter: Nostr::Filter.new(since: 1230981305))
    #
    # @param subscription_id [String] The subscription id. An arbitrary, non-empty string of max length 64
    #   chars used to represent a subscription.
    # @param filter [Filter] A set of attributes that represent the events that the client is interested in.
    #
    # @return [Subscription] The subscription object
    #
    def subscribe(subscription_id: SecureRandom.hex, filter: Filter.new)
      subscriptions[subscription_id] = Subscription.new(id: subscription_id, filter:)
      parent_to_child_channel.push([ClientMessageType::REQ, subscription_id, filter.to_h].to_json)
      subscriptions[subscription_id]
    end

    # Stops a previous subscription
    #
    # @api public
    #
    # @example Stopping a subscription
    #  client.unsubscribe(subscription.id)
    #
    # @example Stopping a subscription
    #  client.unsubscribe('my-subscription')
    #
    # @param subscription_id [String] ID of a previously created subscription.
    #
    # @return [void]
    #
    def unsubscribe(subscription_id)
      subscriptions.delete(subscription_id)
      parent_to_child_channel.push([ClientMessageType::CLOSE, subscription_id].to_json)
    end

    # Sends an event to a Relay
    #
    # @api public
    #
    # @example Sending an event to a relay
    #  client.publish(event)
    #
    # @param event [Event] The event to be sent to a Relay
    #
    # @return [void]
    #
    def publish(event)
      parent_to_child_channel.push([ClientMessageType::EVENT, event.to_h].to_json)
    end

    private

    # The subscriptions that the client has created
    #
    # @api private
    #
    # @return [Hash{String=>Subscription}>]
    #
    attr_reader :subscriptions

    # The channel that the parent thread uses to send messages to the child thread
    #
    # @api private
    #
    # @return [EventMachine::Channel]
    #
    attr_reader :parent_to_child_channel

    # The channel that the child thread uses to send messages to the parent thread
    #
    # @api private
    #
    # @return [EventMachine::Channel]
    #
    attr_reader :child_to_parent_channel

    # Executes a block of code within the EventMachine thread
    #
    # @api private
    #
    # @return [Thread]
    #
    def execute_within_an_em_thread(&block)
      Thread.new { EventMachine.run(block) }
    end

    # Creates the communication channels between threads
    #
    # @api private
    #
    # @return [void]
    #
    def initialize_channels
      @parent_to_child_channel = EventMachine::Channel.new
      @child_to_parent_channel = EventMachine::Channel.new

      child_to_parent_channel.subscribe do |msg|
        emit :connect                           if msg[:type] == :open
        emit :message, msg[:data]               if msg[:type] == :message
        emit :error,   msg[:message]            if msg[:type] == :error
        emit :close,   msg[:code], msg[:reason] if msg[:type] == :close
      end
    end
  end
end
