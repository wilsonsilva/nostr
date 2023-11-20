# frozen_string_literal: true

module Nostr
  # Abstract class for all keys
  #
  # @api private
  #
  class Key < String
    # The regular expression for hexadecimal lowercase characters
    #
    # @return [Regexp] The regular expression for hexadecimal lowercase characters
    #
    FORMAT = /^[a-f0-9]+$/

    # The length of the key in hex format
    #
    # @return [Integer] The length of the key in hex format
    #
    LENGTH = 64

    # Instantiates a new key. Can't be used directly because this is an abstract class. Raises a +ValidationError+
    #
    # @see Nostr::PrivateKey
    # @see Nostr::PublicKey
    #
    # @param [String] hex_value Hex-encoded value of the key
    #
    # @raise [ValidationError]
    #
    def initialize(hex_value)
      validate_hex_value(hex_value)

      super(hex_value)
    end

    # Instantiates a key from a bech32 string
    #
    # @api public
    #
    # @example
    #   bech32_key = 'nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5'
    #   bech32_key.to_key # => #<Nostr::PublicKey:0x000000010601e3c8 @hex_value="...">
    #
    # @raise [Nostr::InvalidHRPError] if the bech32 string is invalid.
    #
    # @param [String] bech32_value The bech32 string representation of the key.
    #
    # @return [Key] the key.
    #
    def self.from_bech32(bech32_value)
      type, data = Bech32.decode(bech32_value)

      raise InvalidHRPError.new(type, hrp) unless type == hrp

      new(data)
    end

    # Abstract method to be implemented by subclasses to provide the HRP (npub, nsec)
    #
    # @api private
    #
    # @return [String] The HRP
    #
    def self.hrp
      raise 'Subclasses must implement this method'
    end

    # Converts the key to a bech32 string representation
    #
    # @api public
    #
    # @example Converting a private key to a bech32 string
    #   public_key = Nostr::PrivateKey.new('67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa')
    #   public_key.to_bech32 # => 'nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5'
    #
    # @example Converting a public key to a bech32 string
    #   public_key = Nostr::PublicKey.new('7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e')
    #   public_key.to_bech32 # => 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'
    #
    # @return [String] The bech32 string representation of the key
    #
    def to_bech32 = Bech32.encode(hrp: self.class.hrp, data: self)

    protected

    # Validates the hex value during initialization
    #
    # @api private
    #
    # @param [String] _hex_value The hex value of the key
    #
    # @raise [KeyValidationError] When the hex value is invalid
    #
    # @return [void]
    #
    def validate_hex_value(_hex_value)
      raise 'Subclasses must implement this method'
    end
  end
end
