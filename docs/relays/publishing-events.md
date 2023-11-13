# Publishing events

Create a [signed event](../core/keys) and call the method
[`Nostr::Client#publish`](https://www.rubydoc.info/gems/nostr/Nostr/Client#publish-instance_method) to send the
event to the relay.

```ruby{4-8,17}
# Create a user with the keypair
user = Nostr::User.new(keypair: keypair)

# Create a signed event
text_note_event = user.create_event(
  kind: Nostr::EventKind::TEXT_NOTE,
  content: 'Your feedback is appreciated, now pay $8'
)

# Connect asynchronously to a relay
relay = Nostr::Relay.new(url: 'wss://nostr.wine', name: 'Wine')
client.connect(relay)

# Listen asynchronously for the connect event
client.on :connect do
  # Send the event to the relay
  client.publish(text_note_event)
end
```

The relay will verify the signature of the event with the public key. If the signature is valid, the relay should
broadcast the event to all subscribers.
