# frozen_string_literal: true

module Nostr
  # Raised when the signature is not a string
  #
  # @api public
  #
  class InvalidSignatureTypeError < SignatureValidationError
    # Initializes the error
    #
    # @example
    #   InvalidSignatureTypeError.new
    #
    def initialize = super('Invalid signature type. It must be a string with lowercase hexadecimal characters.')
  end
end
