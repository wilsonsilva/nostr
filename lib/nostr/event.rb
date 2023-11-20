# frozen_string_literal: true

module Nostr
  # The only object type that exists in Nostr is an event. Events are immutable.
  class Event
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

    # 32-bytes sha256 of the the serialized event data.
    # To obtain the event.id, we sha256 the serialized event. The serialization is done over the UTF-8 JSON-serialized
    # string (with no white space or line breaks)
    #
    # @api public
    #
    # @example Getting the event id
    #   event.id # => 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460'
    #
    # @example Setting the event id
    #   event.id = 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460'
    #   event.id # => 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460'
    #
    # @return [String|nil]
    #
    attr_accessor :id

    # 64-bytes signature of the sha256 hash of the serialized event data, which is
    # the same as the "id" field
    #
    # @api public
    #
    # @example Getting the event signature
    #   event.sig # => ''
    #
    # @example Setting the event signature
    #   event.sig = '058613f8d34c053294cc28b7f9e1f8f0e80fd1ac94fb20f2da6ca514e7360b39'
    #   event.sig # => '058613f8d34c053294cc28b7f9e1f8f0e80fd1ac94fb20f2da6ca514e7360b39'
    #
    # @return [String|nil]
    #
    attr_accessor :sig

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
    # @param id [String|nil] 32-bytes sha256 of the the serialized event data.
    # @param sig [String|nil] 64-bytes signature of the sha256 hash of the serialized event data, which is
    # the same as the "id" field
    # @param pubkey [String] 32-bytes hex-encoded public key of the event creator.
    # @param created_at [Integer] Date of the creation of the vent. A UNIX timestamp, in seconds.
    # @param kind [Integer] The kind of the event. An integer from 0 to 3.
    # @param tags [Array<Array>] An array of tags. Each tag is an array of strings.
    # @param content [String] Arbitrary string.
    #
    def initialize(
      pubkey:,
      kind:,
      content:,
      created_at: Time.now.to_i,
      tags: [],
      id: nil,
      sig: nil
    )
      @id = id
      @sig = sig
      @pubkey = pubkey
      @created_at = created_at
      @kind = kind
      @tags = tags
      @content = content
    end

    # Adds a reference to an event id as an 'e' tag
    #
    # @api public
    #
    # @example Adding a reference to a pubkey
    #   event_id = '189df012cfff8a075785b884bd702025f4a7a37710f581c4ac9d33e24b585408'
    #   event.add_event_reference(event_id)
    #
    # @param event_id [String] 32-bytes hex-encoded event id.
    #
    # @return [Array<String>] The event's updated list of tags
    #
    def add_event_reference(event_id) = tags.push(['e', event_id])

    # Adds a reference to a pubkey as a 'p' tag
    #
    # @api public
    #
    # @example Adding a reference to a pubkey
    #   pubkey = '48df4af6e240ac5f7c5de89bf5941b249880be0e87d03685b178ccb1a315f52e'
    #   event.add_pubkey_reference(pubkey)
    #
    # @param pubkey [PublicKey] 32-bytes hex-encoded public key.
    #
    # @return [Array<String>] The event's updated list of tags
    #
    def add_pubkey_reference(pubkey) = tags.push(['p', pubkey.to_s])

    # Signs an event with the user's private key
    #
    # @api public
    #
    # @example Signing an event
    #   event.sign(private_key)
    #
    # @param private_key [PrivateKey] 32-bytes hex-encoded private key.
    #
    # @return [Event] A signed event.
    #
    def sign(private_key)
      crypto = Crypto.new
      crypto.sign_event(self, private_key)
    end

    # Serializes the event, to obtain a SHA256 digest of it
    #
    # @api public
    #
    # @example Converting the event to a digest
    #   event.serialize
    #
    # @return [Array] The event as an array.
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
