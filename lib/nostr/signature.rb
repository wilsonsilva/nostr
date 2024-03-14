# frozen_string_literal: true

module Nostr
  # 64-bytes lowercase hex of the signature of the sha256 hash of the serialized event data,
  # which is the same as the "id" field
  class Signature < String
    # The regular expression for hexadecimal lowercase characters
    #
    # @return [Regexp] The regular expression for hexadecimal lowercase characters
    #
    FORMAT = /^[a-f0-9]+$/

    # The length of the signature in hex format
    #
    # @return [Integer] The length of the signature in hex format
    #
    LENGTH = 128

    # Instantiates a new Signature
    #
    # @api public
    #
    # @example Instantiating a new signature
    #  Nostr::Signature.new(
    #    'f418c97b50cc68227e82f4f3a79d79eb2b7a0fa517859c86e1a8fa91e3741b7f' \
    #    '06e070c44129227b83fcbe93cecb02a346804a4080ce47685ecad60ab4f5f128'
    #  )
    #
    # @param [String] hex_value Hex-encoded value of the signature
    #
    # @raise [SignatureValidationError]
    #
    def initialize(hex_value)
      validate(hex_value)

      super(hex_value)
    end

    private

    # Hex-encoded value of the signature
    #
    # @api private
    #
    # @return [String] hex_value Hex-encoded value of the signature
    #
    attr_reader :hex_value

    # Validates the hex value of the signature
    #
    # @api private
    #
    # @param [String] hex_value The signature in hex format
    #
    # @raise InvalidSignatureTypeError when the signature is not a string
    # @raise InvalidSignatureLengthError when the signature's length is not 128 characters
    # @raise InvalidSignatureFormatError when the signature is in an invalid format
    #
    # @return [void]
    #
    def validate(hex_value)
      raise InvalidSignatureTypeError   unless hex_value.is_a?(String)
      raise InvalidSignatureLengthError unless hex_value.size == LENGTH
      raise InvalidSignatureFormatError unless hex_value.match(FORMAT)
    end
  end
end
