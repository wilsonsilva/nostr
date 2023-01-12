# frozen_string_literal: true

module Nostr
  # Relays expose a websocket endpoint to which clients can connect.
  class Relay
    # The websocket URL of the relay
    #
    # @api public
    #
    # @example
    #   relay.url # => 'wss://relay.damus.io'
    #
    # @return [String]
    #
    attr_reader :url

    # The name of the relay
    #
    # @api public
    #
    # @example
    #   relay.name # => 'Damus'
    #
    # @return [String]
    #
    attr_reader :name

    # Instantiates a new Relay
    #
    # @api public
    #
    # @example
    #   relay = Nostr::Relay.new(url: 'wss://relay.damus.io', name: 'Damus')
    #
    # @return [String] The websocket URL of the relay
    # @return [String] The name of the relay
    #
    def initialize(url:, name:)
      @url = url
      @name = name
    end
  end
end
