# frozen_string_literal: true

module Nostr
  # Raised when the private key is in an invalid format
  #
  # @api public
  #
  class InvalidKeyFormatError < KeyValidationError
    # Initializes the error
    #
    # @example
    #   InvalidKeyFormatError.new('private')
    #
    # @param [String] key_kind The kind of key that is invalid (public or private)
    #
    def initialize(key_kind)
      super("Only lowercase hexadecimal characters are allowed in #{key_kind} keys.")
    end
  end
end
