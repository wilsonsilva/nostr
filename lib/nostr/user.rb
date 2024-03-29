# frozen_string_literal: true

require 'schnorr'
require 'json'

module Nostr
  # Each user has a keypair. Signatures, public key, and encodings are done according to the
  # Schnorr signatures standard for the curve secp256k1.
  class User
    # A pair of private and public keys
    #
    # @api public
    #
    # @example
    #   user.keypair # #<Nostr::KeyPair:0x0000000107bd3550
    #    @private_key="893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900",
    #    @public_key="2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558">
    #
    # @return [KeyPair]
    #
    attr_reader :keypair

    # Instantiates a user
    #
    # @api public
    #
    # @example Creating a user with no keypair
    #   user = Nostr::User.new
    #
    # @example Creating a user with a keypair
    #   user = Nostr::User.new(keypair: keypair)
    #
    # @param keypair [Keypair] A pair of private and public keys
    # @param keygen [Keygen] A private key and public key generator
    #
    def initialize(keypair: nil, keygen: Keygen.new)
      @keypair = keypair || keygen.generate_key_pair
    end

    # Builds an Event
    #
    # @api public
    #
    # @example Creating a note event
    #   event = user.create_event(
    #     kind: Nostr::EventKind::TEXT_NOTE,
    #     content: 'Your feedback is appreciated, now pay $8'
    #   )
    #
    # @param created_at [Integer] Date of the creation of the vent. A UNIX timestamp, in seconds.
    # @param kind [Integer] The kind of the event. An integer from 0 to 3.
    # @param tags [Array<Array>] An array of tags. Each tag is an array of strings.
    # @param content [String] Arbitrary string.
    #
    # @return [Event]
    #
    def create_event(
      kind:,
      content:,
      created_at: Time.now.to_i,
      tags: []
    )
      event = Event.new(
        pubkey: keypair.public_key,
        kind:,
        content:,
        created_at:,
        tags:
      )
      event.sign(keypair.private_key)
    end
  end
end
