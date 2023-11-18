require_relative 'key_validation_error'

module Nostr
  # Raised when the public key is in an invalid format
  #
  # @api public
  #
  class InvalidPublicKeyFormatError < KeyValidationError
    # Initializes the error
    #
    # @example
    #   InvalidPublicKeyFormatError.new
    #
    def initialize = super('Only lowercase hexadecimal characters are allowed.')
  end
end
