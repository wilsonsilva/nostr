# frozen_string_literal: true

module Nostr
  # Raised when the signature's length is not 128 characters
  #
  # @api public
  #
  class InvalidSignatureLengthError < SignatureValidationError
    # Initializes the error
    #
    # @example
    #   InvalidSignatureLengthError.new
    #
    def initialize
      super('Invalid signature length. It should have 128 characters.')
    end
  end
end
