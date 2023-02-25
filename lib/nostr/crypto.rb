# frozen_string_literal: true

module Nostr
  # Performs cryptographic operations on a +Nostr::Event+.
  class Crypto
    # Uses the private key to generate an event id and sign the event
    #
    # @api public
    #
    # @example Signing an event
    #   crypto = Nostr::Crypto.new
    #   crypto.sign(event, private_key)
    #   event.id # => an id
    #   event.sig # => a signature
    #
    # @param event [Event] The event to be signed
    # @param private_key [String] 32-bytes hex-encoded private key.
    #
    # @return [Event] An unsigned event.
    #
    def sign_event(event, private_key)
      event_digest = hash_event(event)

      hex_private_key = Array(private_key).pack('H*')
      hex_message     = Array(event_digest).pack('H*')
      event_signature = Schnorr.sign(hex_message, hex_private_key).encode.unpack1('H*')

      event.id = event_digest
      event.sig = event_signature

      event
    end

    private

    # Generates a SHA256 hash of a +Nostr::Event+
    #
    # @api private
    #
    # @param event [Event] The event to be hashed
    #
    # @return [String] A SHA256 digest of the event
    #
    def hash_event(event)
      Digest::SHA256.hexdigest(JSON.dump(event.serialize))
    end
  end
end
