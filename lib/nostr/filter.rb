# frozen_string_literal: true

module Nostr
  # A filter determines what events will be sent in a subscription.
  class Filter
    # A list of event ids
    #
    # @api public
    #
    # @example
    #   filter.ids # => ['c24881c305c5cfb7c1168be7e9b0e150', '35deb2612efdb9e13e8b0ca4fc162341']
    #
    # @return [Array<String>, nil]
    #
    attr_reader :ids

    # A list of pubkeys, the pubkey of an event must be one of these
    #
    # @api public
    #
    # @example
    #   filter.authors # => ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7']
    #
    # @return [Array<String>, nil]
    #
    attr_reader :authors

    # A list of a kind numbers
    #
    # @api public
    #
    # @example
    #   filter.kinds # => [0, 1, 2]
    #
    # @return [Array<Integer>, nil]
    #
    attr_reader :kinds

    # A list of event ids that are referenced in an "e" tag
    #
    # @api public
    #
    # @example
    #   filter.e # => ['7bdb422f254194ae4bb86d354c0bd5a888fce233ffc77dceb3e844ceec1fcfb2']
    #
    # @return [Array<String>, nil]
    #
    attr_reader :e

    # A list of pubkeys that are referenced in a "p" tag
    #
    # @api public
    #
    # @example
    #   filter.p # => ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7']
    #
    # @return [Array<String>, nil]
    #
    attr_reader :p

    # A timestamp, events must be newer than this to pass
    #
    # @api public
    #
    # @example
    #   filter.since # => 1230981305
    #
    # @return [Integer, nil]
    #
    attr_reader :since

    # A timestamp, events must be older than this to pass
    #
    # @api public
    #
    # @example
    #   filter.until # => 1292190341
    #
    # @return [Integer, nil]
    #
    attr_reader :until

    # Maximum number of events to be returned in the initial query
    #
    # @api public
    #
    # @example
    #   filter.limit # => 420
    #
    # @return [Integer, nil]
    #
    attr_reader :limit

    # Instantiates a new Filter
    #
    # @api public
    #
    # @example
    #   Nostr::Filter.new(
    #     ids: ['c24881c305c5cfb7c1168be7e9b0e150'],
    #     authors: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
    #     kinds: [0, 1, 2],
    #     since: 1230981305,
    #     until: 1292190341,
    #     e: ['7bdb422f254194ae4bb86d354c0bd5a888fce233ffc77dceb3e844ceec1fcfb2'],
    #     p: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7']
    #   )
    #
    # @param kwargs [Hash]
    # @option kwargs [Array<String>, nil] ids A list of event ids
    # @option kwargs [Array<String>, nil] authors A list of pubkeys, the pubkey of an event must be one
    # of these
    # @option kwargs [Array<Integer>, nil] kinds A list of a kind numbers
    # @option kwargs [Array<String>, nil] e A list of event ids that are referenced in an "e" tag
    # @option kwargs [Array<String, nil>] p A list of pubkeys that are referenced in a "p" tag
    # @option kwargs [Integer, nil] since A timestamp, events must be newer than this to pass
    # @option kwargs [Integer, nil] until A timestamp, events must be older than this to pass
    # @option kwargs [Integer, nil] limit Maximum number of events to be returned in the initial query
    #
    def initialize(**kwargs)
      @ids = kwargs[:ids]
      @authors = kwargs[:authors]
      @kinds = kwargs[:kinds]
      @e = kwargs[:e]
      @p = kwargs[:p]
      @since = kwargs[:since]
      @until = kwargs[:until]
      @limit = kwargs[:limit]
    end

    # Converts the filter to a hash, removing all empty attributes
    #
    # @api public
    #
    # @example
    #   filter.to_h # =>
    #   {
    #      ids: ['c24881c305c5cfb7c1168be7e9b0e150'],
    #      authors: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
    #      kinds: [0, 1, 2],
    #      '#e': ['7bdb422f254194ae4bb86d354c0bd5a888fce233ffc77dceb3e844ceec1fcfb2'],
    #      '#p': ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
    #      since: 1230981305,
    #      until: 1292190341
    #   }
    #
    # @return [Hash] The filter as a hash.
    #
    def to_h
      {
        ids:,
        authors:,
        kinds:,
        '#e': e,
        '#p': p,
        since:,
        until: self.until,
        limit:
      }.compact
    end

    # Compares two filters. Returns true if all attributes are equal and false otherwise
    #
    # @api public
    #
    # @example
    #  filter == filter # => true
    #
    # @return [Boolean] True if all attributes are equal and false otherwise
    #
    def ==(other)
      to_h == other.to_h
    end
  end
end
