# frozen_string_literal: true

module Nostr
  # 32-bytes lowercase hex-encoded public key
  class PublicKey < Key
    # Human-readable part of the Bech32 encoded address
    #
    # @api private
    #
    # @return [String] The human-readable part of the Bech32 encoded address
    #
    def self.hrp
      'npub'
    end

    private

    # Validates the hex value of the public key
    #
    # @api private
    #
    # @param [String] hex_value The public key in hex format
    #
    # @raise InvalidPublicKeyTypeError when the public key is not a string
    # @raise InvalidPublicKeyLengthError when the public key's length is not 64 characters
    # @raise InvalidPublicKeyFormatError when the public key is in an invalid format
    #
    # @return [void]
    #
    def validate_hex_value(hex_value)
      raise InvalidPublicKeyTypeError unless hex_value.is_a?(String)
      raise InvalidPublicKeyLengthError unless hex_value.size == Key::LENGTH
      raise InvalidPublicKeyFormatError unless hex_value.match(Key::FORMAT)
    end
  end
end
