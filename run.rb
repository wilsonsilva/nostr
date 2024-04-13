require_relative 'lib/nostr'
require 'dotenv'

Dotenv.load('.env.development.local')

client = Nostr::Client.new

keygen = Nostr::Keygen.new
keypair = keygen.get_key_pair_from_private_key(
  Nostr::PrivateKey.new(ENV.fetch('NOSTR_DEV_PRIVATE_KEY'))
)

user = Nostr::User.new(keypair: keypair)

text_note_event = user.create_event(
  kind: Nostr::EventKind::TEXT_NOTE,
  content: 'Your feedback is appreciated, now pay $8'
)

relay = Nostr::Relay.new(url: 'wss://bitcoiner.social', name: 'Bitcoiner Social')
client.connect(relay)

client.on :connect do
  client.publish(text_note_event)

  filter = Nostr::Filter.new(
    kinds: [
      Nostr::EventKind::TEXT_NOTE,
      Nostr::EventKind::ENCRYPTED_DIRECT_MESSAGE
    ],
    since: Time.now.to_i - 3600, # 1 hour ago
    until: Time.now.to_i,
    limit: 20,
  )

  subscription = client.subscribe(filter: filter)

  client.unsubscribe(subscription.id)
end

gets
