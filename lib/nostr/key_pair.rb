# frozen_string_literal: true

module Nostr
  # A pair of public and private keys
  class KeyPair
    # 32-bytes hex-encoded private key
    #
    # @api public
    #
    # @example
    #   keypair.private_key # => '893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900'
    #
    # @return [PrivateKey]
    #
    attr_reader :private_key

    # 32-bytes hex-encoded public key
    #
    # @api public
    #
    # @example
    #   keypair.public_key # => '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558'
    #
    # @return [PublicKey]
    #
    attr_reader :public_key

    # Instantiates a key pair
    #
    # @api public
    #
    # @example
    #   keypair = Nostr::KeyPair.new(
    #     private_key: Nostr::PrivateKey.new('893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900'),
    #     public_key: Nostr::PublicKey.new('2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558'),
    #   )
    #
    # @param private_key [PrivateKey] 32-bytes hex-encoded private key.
    # @param public_key [PublicKey] 32-bytes hex-encoded public key.
    #
    # @raise ArgumentError when the private key is not a {PrivateKey}
    # @raise ArgumentError when the public key is not a {PublicKey}
    #
    def initialize(private_key:, public_key:)
      validate_keys(private_key, public_key)

      @private_key = private_key
      @public_key = public_key
    end

    # Allows array destructuring of the KeyPair, enabling the extraction of +PrivateKey+ and +PublicKey+ separately
    #
    # @api public
    #
    # @example Implicit usage of `to_ary` for destructuring
    #   keypair = Nostr::KeyPair.new(
    #     private_key: Nostr::PrivateKey.new('7d1e4219a5e7d8342654c675085bfbdee143f0eb0f0921f5541ef1705a2b407d'),
    #     public_key: Nostr::PublicKey.new('15678d8fbc126fa326fac536acd5a6dcb5ef64b3d939abe31d6830cba6cd26d6'),
    #   )
    #   # The `to_ary` method can be implicitly used for array destructuring:
    #   private_key, public_key = keypair
    #   # Now `private_key` and `public_key` hold the respective values.
    #
    # @example Explicit usage of `to_ary`
    #   array_representation = keypair.to_ary
    #   # array_representation is now an array: [PrivateKey, PublicKey]
    #   # where PrivateKey and PublicKey are the respective objects.
    #
    # @return [Array<PrivateKey, PublicKey>] An array containing the {PrivateKey} and {PublicKey} in that order
    #
    def to_ary
      [private_key, public_key]
    end

    private

    # Validates the keys
    #
    # @api private
    #
    # @param private_key [PrivateKey] 32-bytes hex-encoded private key.
    # @param public_key [PublicKey] 32-bytes hex-encoded public key.
    #
    # @raise ArgumentError when the private key is not a +PrivateKey+
    # @raise ArgumentError when the public key is not a +PublicKey+
    #
    # @return [void]
    #
    def validate_keys(private_key, public_key)
      raise ArgumentError, 'private_key is not an instance of PrivateKey' unless private_key.is_a?(Nostr::PrivateKey)
      raise ArgumentError, 'public_key is not an instance of PublicKey' unless public_key.is_a?(Nostr::PublicKey)
    end
  end
end
