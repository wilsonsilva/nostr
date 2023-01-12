# frozen_string_literal: true

module Nostr
  # Defines the event kinds that can be emitted by clients.
  module EventKind
    # The content is set to a stringified JSON object +{name: <username>, about: <string>,
    # picture: <url, string>}+ describing the user who created the event. A relay may delete past set_metadata
    # events once it gets a new one for the same pubkey.
    #
    # @return [Integer]
    #
    SET_METADATA = 0

    # The content is set to the text content of a note (anything the user wants to say).
    # Non-plaintext notes should instead use kind 1000-10000 as described in NIP-16.
    #
    # @return [Integer]
    #
    TEXT_NOTE = 1

    # The content is set to the URL (e.g., wss://somerelay.com) of a relay the event creator wants to
    # recommend to its followers.
    #
    # @return [Integer]
    #
    RECOMMEND_SERVER = 2
  end
end
