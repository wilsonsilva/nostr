module Nostr
  module TagMarkers
    # @return [String] Denotes the id of the reply event being responded to.
    REPLY = 'reply'

    # @return [String] Denotes the root id of the reply thread being responded to. For top level
    # replies (those replying directly to the root event), only the "root" marker should be used.
    ROOT = 'root'

    # @return [String] Denotes a quoted or reposted event id.
    MENTION = 'mention'
  end
end
