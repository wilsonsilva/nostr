# frozen_string_literal: true

module Nostr
  # Clients can send 3 types of messages, which must be JSON arrays
  module ClientMessageType
    # @return [String] Used to publish events
    EVENT = 'EVENT'

    # @return [String] Used to request events and subscribe to new updates
    REQ = 'REQ'

    # @return [String] Used to stop previous subscriptions
    CLOSE = 'CLOSE'
  end
end
