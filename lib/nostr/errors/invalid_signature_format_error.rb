# frozen_string_literal: true

module Nostr
  # Raised when the signature is in an invalid format
  #
  # @api public
  #
  class InvalidSignatureFormatError < SignatureValidationError
    # Initializes the error
    #
    # @example
    #   InvalidSignatureFormatError.new
    #
    def initialize
      super('Only lowercase hexadecimal characters are allowed in signatures.')
    end
  end
end
