# User

The class [`Nostr::User`](https://www.rubydoc.info/gems/nostr/Nostr/User) is an abstraction to facilitate the creation
of signed events. It is not required to use it to create events, but it is recommended.

Here's an example of how to create a signed event without the class `Nostr::User`:

```ruby
event = Nostr::Event.new(
  pubkey: keypair.public_key,
  kind: Nostr::EventKind::TEXT_NOTE,
  tags: [],
  content: 'Your feedback is appreciated, now pay $8',
)
event.sign(keypair.private_key)
```

::: details Click me to view the event

```ruby
# event.to_h
{
  id: '5feb10973dbcf5f210cfc1f0aa338fee62bed6a29696a67957713599b9baf0eb',
  pubkey: 'b9b9821074d1b60b8fb4a3983632af3ef9669f55b20d515bf982cda5c439ad61',
  created_at: 1699847447,
  kind: 1, # Nostr::EventKind::TEXT_NOTE,
  tags: [],
  content: 'Your feedback is appreciated, now pay $8',
  sig: 'e30f2f08331f224e41a4099d16aefc780bf9f2d1191b71777e1e1789e6b51fdf7bb956f25d4ea9a152d1c66717a9d68c081ce6c89c298c3c5e794914013381ab'
}
```
:::

And here's how to create it with the class `Nostr::User`:

```ruby
user = Nostr::User.new(keypair: keypair)

event = user.create_event(
  kind: Nostr::EventKind::TEXT_NOTE,
  content: 'Your feedback is appreciated, now pay $8'
)
```
