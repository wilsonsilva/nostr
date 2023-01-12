# frozen_string_literal: true

module Nostr
  # The only object type that exists in Nostr is an event. Events are immutable.
  class Event < EventFragment
    # 32-bytes sha256 of the the serialized event data.
    # To obtain the event.id, we sha256 the serialized event. The serialization is done over the UTF-8 JSON-serialized
    # string (with no white space or line breaks)
    #
    # @api public
    #
    # @example Getting the event id
    #   event.id # => 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460'
    #
    # @return [String]
    #
    attr_reader :id

    # 64-bytes signature of the sha256 hash of the serialized event data, which is
    # the same as the "id" field
    #
    # @api public
    #
    # @example Getting the event signature
    #   event.sig # => ''
    #
    # @return [String]
    #
    attr_reader :sig

    # Instantiates a new Event
    #
    # @api public
    #
    # @example Instantiating a new event
    #   Nostr::Event.new(
    #    id: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
    #    pubkey: '48df4af6e240ac5f7c5de89bf5941b249880be0e87d03685b178ccb1a315f52e',
    #    created_at: 1230981305,
    #    kind: 1,
    #    tags: [],
    #    content: 'Your feedback is appreciated, now pay $8',
    #    sig: '123ac2923b792ce730b3da34f16155470ab13c8f97f9c53eaeb334f1fb3a5dc9a7f643
    #          937c6d6e9855477638f5655c5d89c9aa5501ea9b578a66aced4f1cd7b3'
    # )
    #
    #
    # @param id [String] 32-bytes sha256 of the the serialized event data.
    # @param sig [String] 64-bytes signature of the sha256 hash of the serialized event data, which is
    # the same as the "id" field
    #
    def initialize(id:, sig:, **kwargs)
      super(**kwargs)

      @id = id
      @sig = sig
    end

    # Converts the event to a hash
    #
    # @api public
    #
    # @example Converting the event to a hash
    #  event.to_h
    #
    # @return [Hash] The event as a hash.
    #
    def to_h
      {
        id:,
        pubkey:,
        created_at:,
        kind:,
        tags:,
        content:,
        sig:
      }
    end

    # Compares two events. Returns true if all attributes are equal and false otherwise
    #
    # @api public
    #
    # @example
    #  event1 == event2 # => true
    #
    # @return [Boolean] True if all attributes are equal and false otherwise
    #
    def ==(other)
      to_h == other.to_h
    end
  end
end
