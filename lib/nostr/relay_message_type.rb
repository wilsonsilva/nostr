# frozen_string_literal: true

module Nostr
  # Clients can send 4 types of messages, which must be JSON arrays
  module RelayMessageType
    # @return [String] Used to notify clients all stored events have been sent
    EOSE = 'EOSE'

    # @return [String] Used to send events requested to clients
    EVENT = 'EVENT'

    # @return [String] Used to send human-readable messages to clients
    NOTICE = 'NOTICE'

    # @return [String] Used to notify clients if an EVENT was successful
    OK = 'OK'
  end
end
