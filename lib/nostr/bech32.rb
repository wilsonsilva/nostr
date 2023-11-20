# frozen_string_literal: true

require 'bech32'
require 'bech32/nostr'
require 'bech32/nostr/entity'

module Nostr
  # Bech32 encoding and decoding
  #
  # @api public
  #
  module Bech32
    # Decodes a bech32-encoded string
    #
    # @api public
    #
    # @example
    #   bech32_value = 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'
    #   Nostr::Bech32.decode(bech32_value) # => ['npub', '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d8...']
    #
    # @param [String] bech32_value The bech32-encoded string to decode
    #
    # @return [Array<String, String>] The human readable part and the data
    #
    def self.decode(bech32_value)
      entity = ::Bech32::Nostr::NIP19.decode(bech32_value)

      case entity
      in ::Bech32::Nostr::BareEntity
        [entity.hrp, entity.data]
      in ::Bech32::Nostr::TLVEntity
        [entity.hrp, entity.entries]
      end
    end

    # Encodes data into a bech32 string
    #
    # @api public
    #
    # @example
    #   Nostr::Bech32.encode(hrp: 'npub', data: '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e')
    #   # => 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'
    #
    # @param [String] hrp The human readable part (npub, nsec, nprofile, nrelay, nevent, naddr, etc)
    # @param [String] data The data to encode
    #
    # @return [String] The bech32-encoded string
    #
    def self.encode(hrp:, data:)
      ::Bech32::Nostr::BareEntity.new(hrp, data).encode
    end

    # Encodes a hex-encoded public key into a bech32 string
    #
    # @api public
    #
    # @example
    #   Nostr::Bech32.npub_encode('7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e')
    #   # => 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'
    #
    # @param [String] npub The public key to encode
    #
    # @see Nostr::Bech32#encode
    # @see Nostr::PublicKey#to_bech32
    # @see Nostr::PrivateKey#to_bech32
    #
    # @return [String] The bech32-encoded string
    #
    def self.npub_encode(npub)
      encode(hrp: 'npub', data: npub)
    end

    # Encodes a hex-encoded private key into a bech32 string
    #
    # @api public
    #
    # @example
    #   Nostr::Bech32.nsec_encode('7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e')
    #   # => 'nsec10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'
    #
    # @param [String] nsec The private key to encode
    #
    # @see Nostr::Bech32#encode
    # @see Nostr::PrivateKey#to_bech32
    # @see Nostr::PublicKey#to_bech32
    #
    # @return [String] The bech32-encoded string
    #
    def self.nsec_encode(nsec)
      encode(hrp: 'nsec', data: nsec)
    end

    # Encodes an address into a bech32 string
    #
    # @api public
    #
    # @example
    #   naddr = Nostr::Bech32.naddr_encode(
    #     pubkey: '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e',
    #     relays: ['wss://relay.damus.io', 'wss://nos.lol'],
    #     kind: Nostr::EventKind::TEXT_NOTE,
    #     identifier: 'damus'
    #   )
    #   naddr # => 'naddr1qgs8ul5ug253hlh3n75jne0a5xmjur4urfxpzst88cnegg6ds6ka7ns...'
    #
    # @param [PublicKey] pubkey The public key to encode
    # @param [Array<String>] relays The relays to encode
    # @param [String] kind The kind of address to encode
    # @param [String] identifier The identifier of the address to encode
    #
    # @return [String] The bech32-encoded string
    #
    def self.naddr_encode(pubkey:, relays: [], kind: nil, identifier: nil)
      entry_relays = relays.map do |relay_url|
        ::Bech32::Nostr::TLVEntry.new(::Bech32::Nostr::TLVEntity::TYPE_RELAY, relay_url)
      end

      pubkey_entry = ::Bech32::Nostr::TLVEntry.new(::Bech32::Nostr::TLVEntity::TYPE_AUTHOR, pubkey)
      kind_entry = ::Bech32::Nostr::TLVEntry.new(::Bech32::Nostr::TLVEntity::TYPE_KIND, kind)
      identifier_entry = ::Bech32::Nostr::TLVEntry.new(::Bech32::Nostr::TLVEntity::TYPE_SPECIAL, identifier)

      entries = [pubkey_entry, *entry_relays, kind_entry, identifier_entry].compact
      entity = ::Bech32::Nostr::TLVEntity.new(::Bech32::Nostr::NIP19::HRP_EVENT_COORDINATE, entries)
      entity.encode
    end

    # Encodes an event into a bech32 string
    #
    # @api public
    #
    # @example
    #   nevent = Nostr::Bech32.nevent_encode(
    #     id: '0fdb90f8e234d3400edafdd26d493f12efc0d7de2c6f9f21f997847d33ad2ea3',
    #     relays: ['wss://relay.damus.io', 'wss://nos.lol'],
    #     kind: Nostr::EventKind::TEXT_NOTE,
    #   )
    #   nevent # => 'nevent1qgsqlkuslr3rf56qpmd0m5ndfyl39m7q6l0zcmuly8ue0pra...'
    #
    # @param [PublicKey] id The id the event to encode
    # @param [Array<String>] relays The relays to encode
    # @param [String] kind The kind of event to encode
    #
    # @return [String] The bech32-encoded string
    #
    def self.nevent_encode(id:, relays: [], kind: nil)
      entry_relays = relays.map do |relay_url|
        ::Bech32::Nostr::TLVEntry.new(::Bech32::Nostr::TLVEntity::TYPE_RELAY, relay_url)
      end

      id_entry = ::Bech32::Nostr::TLVEntry.new(::Bech32::Nostr::TLVEntity::TYPE_AUTHOR, id)
      kind_entry = ::Bech32::Nostr::TLVEntry.new(::Bech32::Nostr::TLVEntity::TYPE_KIND, kind)

      entries = [id_entry, *entry_relays, kind_entry].compact
      entity = ::Bech32::Nostr::TLVEntity.new(::Bech32::Nostr::NIP19::HRP_EVENT, entries)
      entity.encode
    end

    # Encodes a profile into a bech32 string
    #
    # @api public
    #
    # @example
    #   nprofile = Nostr::Bech32.nprofile_encode(
    #     pubkey: '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e',
    #     relays: ['wss://relay.damus.io', 'wss://nos.lol']
    #   )
    #
    # @param [PublicKey] pubkey The public key to encode
    # @param [Array<String>] relays The relays to encode
    #
    # @return [String] The bech32-encoded string
    #
    def self.nprofile_encode(pubkey:, relays: [])
      entry_relays = relays.map do |relay_url|
        ::Bech32::Nostr::TLVEntry.new(::Bech32::Nostr::TLVEntity::TYPE_RELAY, relay_url)
      end

      pubkey_entry = ::Bech32::Nostr::TLVEntry.new(::Bech32::Nostr::TLVEntity::TYPE_SPECIAL, pubkey)
      entries = [pubkey_entry, *entry_relays].compact
      entity = ::Bech32::Nostr::TLVEntity.new(::Bech32::Nostr::NIP19::HRP_PROFILE, entries)
      entity.encode
    end

    # Encodes a relay URL into a bech32 string
    #
    # @api public
    #
    # @example
    #   nrelay = Nostr::Bech32.nrelay_encode('wss://relay.damus.io')
    #   nrelay # => 'nrelay1qq28wumn8ghj7un9d3shjtnyv9kh2uewd9hsc5zt2x'
    #
    # @param [String] relay_url The relay url to encode
    #
    # @return [String] The bech32-encoded string
    #
    def self.nrelay_encode(relay_url)
      relay_entry = ::Bech32::Nostr::TLVEntry.new(::Bech32::Nostr::TLVEntity::TYPE_SPECIAL, relay_url)

      entity = ::Bech32::Nostr::TLVEntity.new(::Bech32::Nostr::NIP19::HRP_RELAY, [relay_entry])
      entity.encode
    end
  end
end
