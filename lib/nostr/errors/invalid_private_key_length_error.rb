require_relative 'key_validation_error'

module Nostr
  # Raised when the private key's length is not 64 characters
  #
  # @api public
  #
  class InvalidPrivateKeyLengthError < KeyValidationError
    # Initializes the error
    #
    # @example
    #   InvalidPrivateKeyLengthError.new
    #
    def initialize = super('Invalid private key length. It should have 64 characters.')
  end
end
