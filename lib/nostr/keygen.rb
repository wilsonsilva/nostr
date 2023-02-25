# frozen_string_literal: true

require 'ecdsa'
require 'securerandom'

module Nostr
  # Generates private keys, public keys and key pairs.
  class Keygen
    # Instantiates a new keygen
    #
    # @api public
    #
    # @example
    #   keygen = Nostr::Keygen.new
    #
    def initialize
      @group = ECDSA::Group::Secp256k1
    end

    # Generates a pair of private and public keys
    #
    # @api public
    #
    # @example
    #   keypair = keygen.generate_keypair
    #   keypair # #<Nostr::KeyPair:0x0000000107bd3550
    #    @private_key="893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900",
    #    @public_key="2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558">
    #
    # @return [KeyPair] An object containing a private key and a public key.
    #
    def generate_key_pair
      private_key = generate_private_key
      public_key  = extract_public_key(private_key)

      KeyPair.new(private_key:, public_key:)
    end

    # Generates a private key
    #
    # @api public
    #
    # @example
    #   private_key = keygen.generate_private_key
    #   private_key # => '893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900'
    #
    # @return [String] A 32-bytes hex-encoded private key.
    #
    def generate_private_key
      (SecureRandom.random_number(group.order - 1) + 1).to_s(16)
    end

    # Extracts a public key from a private key
    #
    # @api public
    #
    # @example
    #   private_key = keygen.generate_private_key
    #   public_key = keygen.extract_public_key(private_key)
    #   public_key # => '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558'
    #
    # @return [String] A 32-bytes hex-encoded public key.
    #
    def extract_public_key(private_key)
      group.generator.multiply_by_scalar(private_key.to_i(16)).x.to_s(16).rjust(64, '0')
    end

    private

    # The elliptic curve group. Used to generate public and private keys
    #
    # @api private
    #
    # @return [ECDSA::Group]
    #
    attr_reader :group
  end
end
