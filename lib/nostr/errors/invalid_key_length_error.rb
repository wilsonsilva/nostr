# frozen_string_literal: true

module Nostr
  # Raised when the private key's length is not 64 characters
  #
  # @api public
  #
  class InvalidKeyLengthError < KeyValidationError
    # Initializes the error
    #
    # @example
    #   InvalidKeyLengthError.new('private')
    #
    # @param [String] key_kind The kind of key that is invalid (public or private)
    #
    def initialize(key_kind)
      super("Invalid #{key_kind} key length. It should have 64 characters.")
    end
  end
end
