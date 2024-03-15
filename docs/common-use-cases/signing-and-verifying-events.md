# Signing and verifying events

Signing an event in Nostr proves it was sent by the owner of a specific private key.

## Signing an event

To sign an event, use the private key associated with the event's creator. Here's how to sign a message using a
predefined keypair:

```ruby{14}
require 'nostr'

private_key = Nostr::PrivateKey.new('67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'),
public_key = Nostr::PublicKey.new('7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'),

event = Nostr::Event.new(
  pubkey: public_key.to_s,
  kind: Nostr::EventKind::TEXT_NOTE,
  content: 'We did it with security, now we’re going to do it with the economy.',
  created_at: Time.now.to_i,
)

# Sign the event with the private key
event.sign(private_key)

puts "Event ID: #{event.id}"
puts "Event Signature: #{event.sig}"
```

## Verifying an event's signature

To verify an event, you must ensure the event's signature is valid. This indicates the event was created by the owner
of the corresponding public key.

When the event was signed with the private key corresponding to the public key, the `verify_signature` method will
return `true`.

```ruby
event.verify_signature # => true
```

And when the event was not signed with the private key corresponding to the public key, the `verify_signature` method
will return `false`.

An event without an `id`, `pubkey`, `sig` is considered invalid and will return `false` when calling `verify_signature`.

```ruby
other_public_key = Nostr::PublicKey.new('10be96d345ed58d923a734560680f1adfd2b1006c28ac93b8e1b032a9a32c6e9')
event.verify_signature # => false
```
