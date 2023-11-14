# frozen_string_literal: true

module Nostr
  module Tags
    class P
      NAME = 'p'

      def initialize(pubkey:, relay_url: '', petname: nil)
        @pubkey = pubkey
        @relay_url = relay_url
        @petname = petname
      end

      def to_a
        [NAME, pubkey, relay_url, petname].compact
      end

      def to_json(*_args)
        to_a.to_json
      end

      attr_reader :pubkey, :relay_url, :petname
    end
  end
end

# name	value	other parameters	NIP
# e	event id (hex)	relay URL, marker	01, 10
# p	pubkey (hex)	relay URL, petname	01, 02
# a	coordinates to an event	relay URL	01
# d	identifier	--	01
# alt	summary	--	31
# g	geohash	--	52
# i	identity	proof	39
# k	kind number (string)	--	18, 25, 72
# l	label, label namespace	annotations	32
# L	label namespace	--	32
# m	MIME type	--	94
# r	a reference (URL, etc)	petname
# r	relay url	marker	65
# t	hashtag	--
# amount	millisatoshis, stringified	--	57
# bolt11	bolt11 invoice	--	57
# challenge	challenge string	--	42
# content-warning	reason	--	36
# delegation	pubkey, conditions, delegation token	--	26
# description	invoice/badge description	--	57, 58
# emoji	shortcode, image URL	--	30
# expiration	unix timestamp (string)	--	40
# goal	event id (hex)	relay URL	75
# image	image URL	dimensions in pixels	23, 58
# lnurl	bech32 encoded lnurl	--	57
# location	location string	--	52, 99
# name	badge name	--	58
# nonce	random	--	13
# preimage	hash of bolt11 invoice	--	57
# price	price	currency, frequency	99
# proxy	external ID	protocol	48
# published_at	unix timestamp (string)	--	23
# relay	relay url	--	42
# relays	relay list	--	57
# subject	subject	--	14
# summary	article summary	--	23
# thumb	badge thumbnail	dimensions in pixels	58
# title	article title	--	23
# zap	pubkey (hex), relay URL	weight	57
