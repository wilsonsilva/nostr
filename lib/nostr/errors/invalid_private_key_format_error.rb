require_relative 'key_validation_error'

module Nostr
  # Raised when the private key is in an invalid format
  #
  # @api public
  #
  class InvalidPrivateKeyFormatError < KeyValidationError
    # Initializes the error
    #
    # @example
    #   InvalidPrivateKeyFormatError.new
    #
    def initialize = super('Only lowercase hexadecimal characters are allowed.')
  end
end
