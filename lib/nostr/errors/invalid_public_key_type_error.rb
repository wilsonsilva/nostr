require_relative 'key_validation_error'

module Nostr
  # Raised when the public key is not a string
  #
  # @api public
  #
  class InvalidPublicKeyTypeError < KeyValidationError
    # Initializes the error
    #
    # @example
    #   InvalidPublicKeyTypeError.new
    #
    def initialize = super('Invalid public key type')
  end
end
