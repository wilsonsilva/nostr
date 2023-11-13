# Keys

To [sign events](#signing-an-event), you need a **private key**. To verify signatures, you need a **public key**. The combination of a
private and a public key is called a **keypair**.

There are a few ways to generate a keypair.

## a) Generating a keypair

If you don't have any keys, you can generate a keypair using the [`Nostr::Keygen`](https://www.rubydoc.info/gems/nostr/Nostr/Keygen) class:

```ruby
keygen  = Nostr::Keygen.new
keypair = keygen.generate_key_pair

keypair.private_key # => '893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900'
keypair.public_key # => '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558'
```

## b) Generating a private key and a public key

Alternatively, if you have already generated a private key, you can extract the corresponding public key by calling
`Keygen#extract_public_key`:

```ruby
keygen  = Nostr::Keygen.new

private_key = keygen.generate_private_key
public_key  = keygen.extract_public_key(private_key)

private_key # => '893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900'
public_key # => '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558'
```

## c) Using existing keys

If you already have a private key and a public key, you can create a keypair using the `Nostr::KeyPair` class:

```ruby
keypair = Nostr::KeyPair.new(
  private_key: '893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900',
  public_key: '2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558',
)
```

## Signing an event

KeyPairs are used to sign [events](../events). To create a signed event, you need to instantiate a
[`Nostr::User`](https://www.rubydoc.info/gems/nostr/Nostr/User) with a keypair:

```ruby{9,12-15}
# a) Use an existing keypair
keypair = Nostr::KeyPair.new(private_key: 'your-key', public_key: 'your-key')

# b) Or generate a new keypair
keygen = Nostr::Keygen.new
keypair = keygen.generate_key_pair

# Add the keypair to a user
user = Nostr::User.new(keypair: keypair)

# Create signed events
text_note = user.create_event(
  kind: Nostr::EventKind::TEXT_NOTE,
  content: 'Your feedback is appreciated, now pay $8'
)
```

::: details Click me to view the text_note

```ruby
# text_note.to_h
{
  id: '5feb10973dbcf5f210cfc1f0aa338fee62bed6a29696a67957713599b9baf0eb',
  pubkey: 'b9b9821074d1b60b8fb4a3983632af3ef9669f55b20d515bf982cda5c439ad61', # from keypair
  created_at: 1699847447,
  kind: 1, # Nostr::EventKind::TEXT_NOTE,
  tags: [],
  content: 'Your feedback is appreciated, now pay $8',
  sig: 'e30f2f08331f224e41a4099d16aefc780bf9f2d1191b71777e1e1789e6b51fdf7bb956f25d4ea9a152d1c66717a9d68c081ce6c89c298c3c5e794914013381ab'
}
```
:::
