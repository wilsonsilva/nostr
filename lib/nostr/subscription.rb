# frozen_string_literal: true

require 'securerandom'

module Nostr
  # A subscription the result of a request to receive events from a relay
  class Subscription
    # A random string that should be used to represent a subscription
    #
    # @api public
    #
    # @example
    #   subscription.id # => 'c24881c305c5cfb7c1168be7e9b0e150'
    #
    # @return [String]
    #
    attr_reader :id

    # An object that determines what events will be sent in the subscription
    #
    # @api public
    #
    # @example
    #   subscription.filter # => #<Nostr::Subscription:0x0000000110eea460 @filter=#<Nostr::Filter:0x0000000110c24de8>,
    #   @id="0dd7f3fa06cd5f797438dd0b7477f3c7">
    #
    # @return [Filter]
    #
    attr_reader :filter

    # Initializes a subscription
    #
    # @api public
    #
    # @example Creating a subscription with no id and no filters
    #   subscription = Nostr::Subscription.new
    #
    # @example Creating a subscription with an ID
    #   subscription = Nostr::Subscription.new(id: 'c24881c305c5cfb7c1168be7e9b0e150')
    #
    # @example Subscribing to all events created after a certain time
    #   subscription = Nostr::Subscription.new(filter: Nostr::Filter.new(since: 1230981305))
    #
    # @param id [String] A random string that should be used to represent a subscription
    # @param filter [Filter] An object that determines what events will be sent in that subscription
    #
    def initialize(filter:, id: SecureRandom.hex)
      @id = id
      @filter = filter
    end

    # Compares two subscriptions. Returns true if all attributes are equal and false otherwise
    #
    # @api public
    #
    # @example
    #  subscription1 == subscription1 # => true
    #
    # @return [Boolean] True if all attributes are equal and false otherwise
    #
    def ==(other)
      id == other.id && filter == other.filter
    end
  end
end
