# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nostr::Bech32 do
  let(:keypair) { Nostr::Keygen.new.generate_key_pair }
  let(:private_key) { keypair.private_key }
  let(:public_key) { keypair.public_key }

  describe '.encode' do
    it 'encodes data into the bech32 format' do
      npub = described_class.encode(hrp: 'npub', data: public_key)
      expect(npub).to match(/npub1\w+/)
    end
  end

  describe '.decode' do
    it 'decodes data from the bech32 format' do
      npub = described_class.encode(hrp: 'npub', data: public_key)
      type, decoded = described_class.decode(npub)

      aggregate_failures do
        expect(type).to eq('npub')
        expect(decoded).to eq(public_key)
      end
    end
  end

  describe '.nsec_encode' do
    it 'encodes and decodes hexadecimal private keys' do
      nsec = described_class.nsec_encode(private_key)
      type, data = described_class.decode(nsec)

      aggregate_failures do
        expect(nsec).to match(/nsec1\w+/)
        expect(type).to eq('nsec')
        expect(data).to eq(private_key)
      end
    end
  end

  describe '.npub_encode' do
    it 'encodes and decodes hexadecimal public keys' do
      npub = described_class.npub_encode(public_key)
      type, data = described_class.decode(npub)

      aggregate_failures do
        expect(npub).to match(/npub1\w+/)
        expect(type).to eq('npub')
        expect(data).to eq(public_key)
      end
    end
  end

  describe '.nprofile_encode' do
    it 'encodes and decodes nprofiles with relays' do
      relay_urls = %w[wss://relay.damus.io wss://nos.lol]
      nprofile = described_class.nprofile_encode(pubkey: public_key, relays: relay_urls)
      type, profile = described_class.decode(nprofile)

      aggregate_failures do
        expect(nprofile).to match(/nprofile1\w+/)
        expect(type).to eq('nprofile')
        expect(profile.entries[0].value).to eq(public_key)
        expect(profile.entries[1].value).to eq(relay_urls[0])
        expect(profile.entries[2].value).to eq(relay_urls[1])
      end
    end

    it 'encodes and decodes nprofiles without relays' do
      nprofile = described_class.nprofile_encode(pubkey: public_key)
      type, profile = described_class.decode(nprofile)

      aggregate_failures do
        expect(nprofile).to match(/nprofile1\w+/)
        expect(type).to eq('nprofile')
        expect(profile.entries[0].value).to eq(public_key)
      end
    end
  end

  describe '.naddr_encode' do
    it 'encodes and decodes naddr' do
      relay_urls = %w[wss://relay.damus.io wss://nos.lol]
      naddr = described_class.naddr_encode(
        pubkey: public_key,
        relays: relay_urls,
        kind: 1984,
        identifier: 'damus'
      )
      type, addr = described_class.decode(naddr)

      aggregate_failures do
        expect(naddr).to match(/naddr1\w+/)
        expect(type).to eq('naddr')
        expect(addr.entries[0].value).to eq(public_key)
        expect(addr.entries[1].value).to eq(relay_urls[0])
        expect(addr.entries[2].value).to eq(relay_urls[1])
        expect(addr.entries[3].value).to eq(1984)
        expect(addr.entries[4].value).to eq('damus')
      end
    end
  end

  describe '.nevent_encode' do
    it 'encodes and decodes nevent' do
      relay_urls = %w[wss://relay.damus.io wss://nos.lol]
      nevent = described_class.nevent_encode(
        id: '0fdb90f8e234d3400edafdd26d493f12efc0d7de2c6f9f21f997847d33ad2ea3',
        relays: relay_urls,
        kind: Nostr::EventKind::TEXT_NOTE
      )
      type, event = described_class.decode(nevent)

      aggregate_failures do
        expect(nevent).to match(/nevent1\w+/)
        expect(type).to eq('nevent')
        expect(event.entries[0].value).to eq('0fdb90f8e234d3400edafdd26d493f12efc0d7de2c6f9f21f997847d33ad2ea3')
        expect(event.entries[1].value).to eq(relay_urls[0])
        expect(event.entries[2].value).to eq(relay_urls[1])
        expect(event.entries[3].value).to eq(Nostr::EventKind::TEXT_NOTE)
      end
    end
  end

  describe '.nrelay_encode' do
    it 'encodes and decodes nrelay' do
      relay_url = 'wss://relay.damus.io'
      nrelay = described_class.nrelay_encode(relay_url)
      type, data = described_class.decode(nrelay)

      aggregate_failures do
        expect(nrelay).to match(/nrelay1\w+/)
        expect(type).to eq('nrelay')
        expect(data.entries[0].value).to eq(relay_url)
      end
    end
  end
end
