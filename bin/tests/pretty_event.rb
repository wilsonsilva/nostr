class PrettyEvent
  def initialize(event, key_size: 6)
    @id = event.id[0..key_size]
    @pubkey = event.pubkey[0..key_size]
    @created_at = Time.at(event.created_at).strftime("%d/%m/%Y %H:%M:%S")
    @kind = Nostr::EventKind.get_description(event.kind)
    @tags = parse_tags(event.tags, key_size)
    @content = event.content
    @sig = event.sig[0..key_size]
  end

  attr_reader :id, :pubkey, :created_at, :kind, :tags, :content, :sig

  def parse_tags(tags, key_size)
    tags.map do |tag|
      case tag
      in ['p' | 'e' => ep, key, *rest]
        # [ep, key[0...key_size], *rest]
        [ep, key, *rest]
      else
        tag
      end
    end
  end
end
