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
    # @return [String]
    #
    attr_reader :private_key

    # 32-bytes hex-encoded public key
    #
    # @api public
    #
    # @example
    #   keypair.public_key # => '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558'
    #
    # @return [String]
    #
    attr_reader :public_key

    # Instantiates a key pair
    #
    # @api public
    #
    # @example
    #   keypair = Nostr::KeyPair.new(
    #     private_key: '893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900',
    #     public_key: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558',
    #   )
    #
    # @param private_key [String] 32-bytes hex-encoded private key.
    # @param public_key [String] 32-bytes hex-encoded public key.
    #
    def initialize(private_key:, public_key:)
      @private_key = private_key
      @public_key = public_key
    end
  end
end
