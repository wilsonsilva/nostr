require_relative 'key_validation_error'

module Nostr
  # Raised when the public key's length is not 64 characters
  #
  # @api public
  #
  class InvalidPublicKeyLengthError < KeyValidationError
    # Initializes the error
    #
    # @example
    #   InvalidPublicKeyLengthError.new
    #
    def initialize = super('Invalid public key length. It should have 64 characters.')
  end
end
