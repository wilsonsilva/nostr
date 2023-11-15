module Nostr
  module CoreExt
    module String
      refine ::String do
        # Converts a bech32 string to a hex string.
        #
        # @api public
        #
        # @return [String] the hex string.
        #
        def to_hex = ::Nostr::Key.parse(self).to_hex

        # Converts a hex string to a bech32 string.
        #
        # @api public
        #
        # @example
        #   hex_key = '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'
        #   hex_key.to_nsec # => 'nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5'
        #
        # @return [String] the bech32 string.
        #
        def to_nsec = to_bech32('nsec')

        # Converts a hex string to a bech32 string.
        #
        # @api public
        #
        # @example
        #   hex_key = '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
        #   hex_key.to_npub # => 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'
        #
        # @return [String] the bech32 string.
        #
        def to_npub = to_bech32('npub')

        # Converts bech32 string to a descendant of +Nostr::Key+.
        #
        # @api public
        #
        # @example Converting a public key bech32 string to a +Nostr::PublicKey+.
        #   bech32_key = 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'
        #   bech32_key.to_key # => #<Nostr::PublicKey:0x00007f9a1c8b3a00 @hex_value="...">
        #
        # @example Converting a private key bech32 string to a +Nostr::PrivateKey+.
        #   bech32_key = 'nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5'
        #   bech32_key.to_key # => #<Nostr::PublicKey:0x000000010601e3c8 @hex_value="...">
        #
        # @return [Nostr::Key] the public or private key.
        #
        def to_key = ::Nostr::Key.parse(self)

        private

        # Converts a string to a bech32 string.
        #
        # @api private
        #
        # @param [String] hrp the human-readable part of the bech32 string.
        #
        # @return [String] the bech32 string.
        #
        def to_bech32(hrp) = Bech32::Nostr::BareEntity.new(hrp, self).encode
      end
    end
  end
end
