# frozen_string_literal: true

module Nostr
  # 32-bytes lowercase hex-encoded private key
  class PrivateKey < Key
    # Human-readable part of the Bech32 encoded address
    #
    # @api private
    #
    # @return [String] The human-readable part of the Bech32 encoded address
    #
    def self.hrp
      'nsec'
    end

    private

    # Validates the hex value of the private key
    #
    # @api private
    #
    # @param [String] hex_value The private key in hex format
    #
    # @raise InvalidKeyTypeError when the private key is not a string
    # @raise InvalidKeyLengthError when the private key's length is not 64 characters
    # @raise InvalidKeyFormatError when the private key is in an invalid format
    #
    # @return [void]
    #
    def validate_hex_value(hex_value)
      raise InvalidKeyTypeError, 'private'   unless hex_value.is_a?(String)
      raise InvalidKeyLengthError, 'private' unless hex_value.size == Key::LENGTH
      raise InvalidKeyFormatError, 'private' unless hex_value.match(Key::FORMAT)
    end
  end
end
