# frozen_string_literal: true

module Nostr
  # Part of an +Event+. A complete +Event+ must have an +id+ and a +sig+.
  class EventFragment
    # 32-bytes hex-encoded public key of the event creator
    #
    # @api public
    #
    # @example
    #   event.pubkey # => '48df4af6e240ac5f7c5de89bf5941b249880be0e87d03685b178ccb1a315f52e'
    #
    # @return [String]
    #
    attr_reader :pubkey

    # Date of the creation of the vent. A UNIX timestamp, in seconds
    #
    # @api public
    #
    # @example
    #   event.created_at # => 1230981305
    #
    # @return [Integer]
    #
    attr_reader :created_at

    # The kind of the event. An integer from 0 to 3
    #
    # @api public
    #
    # @example
    #   event.kind # => 1
    #
    # @return [Integer]
    #
    attr_reader :kind

    # An array of tags. Each tag is an array of strings
    #
    # @api public
    #
    # @example Tags referencing an event
    #  event.tags #=> [["e", "event_id", "relay URL"]]
    #
    # @example Tags referencing a key
    #  event.tags #=> [["p", "event_id", "relay URL"]]
    #
    # @return [Array<Array>]
    #
    attr_reader :tags

    # An arbitrary string
    #
    # @api public
    #
    # @example
    #  event.content # => 'Your feedback is appreciated, now pay $8'
    #
    # @return [String]
    #
    attr_reader :content

    # Instantiates a new EventFragment
    #
    # @api public
    #
    # @example
    #   Nostr::EventFragment.new(
    #     pubkey: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
    #     created_at: 1230981305,
    #     kind: 1,
    #     tags: [['e', '189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408']],
    #     content: 'Your feedback is appreciated, now pay $8'
    #   )
    #
    # @param pubkey [String] 32-bytes hex-encoded public key of the event creator.
    # @param created_at [Integer] Date of the creation of the vent. A UNIX timestamp, in seconds.
    # @param kind [Integer] The kind of the event. An integer from 0 to 3.
    # @param tags [Array<Array>] An array of tags. Each tag is an array of strings.
    # @param content [String] Arbitrary string.
    #
    def initialize(pubkey:, kind:, content:, created_at: Time.now.to_i, tags: [])
      @pubkey = pubkey
      @created_at = created_at
      @kind = kind
      @tags = tags
      @content = content
    end

    # Serializes the event fragment, to obtain a SHA256 hash of it
    #
    # @api public
    #
    # @example Converting the event to a hash
    #   event_fragment.serialize
    #
    # @return [Array] The event fragment as an array.
    #
    def serialize
      [
        0,
        pubkey,
        created_at,
        kind,
        tags,
        content
      ]
    end
  end
end
