# frozen_string_literal: true

module Nostr
  # Raised when the human readable part of a Bech32 string is invalid
  #
  # @api public
  #
  class InvalidHRPError < KeyValidationError
    # Initializes the error
    #
    # @example
    #   InvalidHRPError.new('example wrong hrp', 'nsec')
    #
    # @param given_hrp [String] The given human readable part of the Bech32 string
    # @param allowed_hrp [String] The allowed human readable part of the Bech32 string
    #
    def initialize(given_hrp, allowed_hrp)
      super("Invalid hrp: #{given_hrp}. The allowed hrp value for this kind of entity is '#{allowed_hrp}'.")
    end
  end
end
