module Nostr
  class Tags < Set
    def add(tag)
      self.push(tag)
    end

    def add_pubkey_reference
    end

    def get_pubkey_references
    end
  end
end

event.tags.add(
  Nostr::Tags::E.new(
    event_id: event.id,
    relay_url: 'wss://relay.service.mapboss.co.th',
    marker: Nostr::TagMarkers::REPLY
  )
)
