require_relative 'key_validation_error'

module Nostr
  # Raised when the private key is not a string
  #
  # @api public
  #
  class InvalidPrivateKeyTypeError < KeyValidationError
    # Initializes the error
    #
    # @example
    #   InvalidPrivateKeyTypeError.new
    #
    def initialize = super('Invalid private key type')
  end
end
