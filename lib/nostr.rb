# frozen_string_literal: true

require_relative 'nostr/errors'
require_relative 'nostr/bech32'
require_relative 'nostr/crypto'
require_relative 'nostr/version'
require_relative 'nostr/keygen'
require_relative 'nostr/client_message_type'
require_relative 'nostr/filter'
require_relative 'nostr/subscription'
require_relative 'nostr/relay'
require_relative 'nostr/relay_message_type'
require_relative 'nostr/key_pair'
require_relative 'nostr/event_kind'
require_relative 'nostr/event'
require_relative 'nostr/events/encrypted_direct_message'
require_relative 'nostr/client'
require_relative 'nostr/user'
require_relative 'nostr/key'
require_relative 'nostr/private_key'
require_relative 'nostr/public_key'

# Encapsulates all the gem's logic
module Nostr
end
