# frozen_string_literal: true

module Nostr
  # Raised when the private key is not a string
  #
  # @api public
  #
  class InvalidKeyTypeError < KeyValidationError
    # Initializes the error
    #
    # @example
    #   InvalidKeyTypeError.new('private')
    #
    # @param [String] key_kind The kind of key that is invalid (public or private)
    #
    def initialize(key_kind) = super("Invalid #{key_kind} key type")
  end
end
