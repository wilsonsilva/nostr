# Keys

To [sign events](#signing-an-event), you need a **private key**. To verify signatures, you need a **public key**. The combination of a
private and a public key is called a **keypair**.

Both public and private keys are 64-character hexadecimal strings. They can be represented in bech32 format,
which is a human-readable format that starts with `nsec` for private keys and `npub` for public keys.

There are a few ways to generate a keypair.

## a) Generating a keypair

If you don't have any keys, you can generate a keypair using the
[`Nostr::Keygen`](https://www.rubydoc.info/gems/nostr/Nostr/Keygen) class:

```ruby
keygen  = Nostr::Keygen.new
keypair = keygen.generate_key_pair

keypair.private_key # => '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'
keypair.public_key # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
```

## b) Generating a private key and a public key

Alternatively, if you have already generated a private key, you can extract the corresponding public key by calling
`Keygen#extract_public_key`:

```ruby
keygen  = Nostr::Keygen.new

private_key = keygen.generate_private_key
public_key  = keygen.extract_public_key(private_key)

private_key # => '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'
public_key # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
```

## c) Using existing hexadecimal keys

If you already have a private key and a public key in hexadecimal format, you can create a keypair using the
`Nostr::KeyPair` class:

```ruby
keypair = Nostr::KeyPair.new(
  private_key: Nostr::PrivateKey.new('67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'),
  public_key: Nostr::PublicKey.new('7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'),
)

keypair.private_key # => '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'
keypair.public_key # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
```

### d) Use existing bech32 keys

If you already have a private key and a public key in bech32 format, you can create a keypair using the
`Nostr::KeyPair` class:

```ruby
keypair = Nostr::KeyPair.new(
  private_key: Nostr::PrivateKey.from_bech32('nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5'),
  public_key: Nostr::PublicKey.from_bech32('npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'),
)

keypair.private_key # => '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'
keypair.public_key # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
```

## e) Using an existing hexadecimal private key

If you already have a private key in hexadecimal format, you can create a keypair using the method
[`Nostr::Keygen#get_key_pair_from_private_key`](https://www.rubydoc.info/gems/nostr/Nostr/Keygen#get_key_pair_from_private_key-instance_method):

```ruby
private_key = Nostr::PrivateKey.new('67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa')

keygen= Nostr::Keygen.new
keypair = keygen.get_key_pair_from_private_key(private_key)

keypair.private_key # => '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'
keypair.public_key # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
```

## f) Using an existing bech32 private key

If you already have a private key in bech32 format, you can create a keypair using the methods
[`Nostr::PrivateKey.from_bech32`](https://www.rubydoc.info/gems/nostr/Nostr/PrivateKey.from_bech32-class_method) and
[`Nostr::Keygen#get_key_pair_from_private_key`](https://www.rubydoc.info/gems/nostr/Nostr/Keygen#get_key_pair_from_private_key-instance_method):

```ruby
private_key = Nostr::PrivateKey.from_bech32('nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5')

keygen= Nostr::Keygen.new
keypair = keygen.get_key_pair_from_private_key(private_key)

keypair.private_key # => '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'
keypair.public_key # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
```

## Signing an event

KeyPairs are used to sign [events](../events). To create a signed event, you need to instantiate a
[`Nostr::User`](https://www.rubydoc.info/gems/nostr/Nostr/User) with a keypair:

```ruby{8,11-14}
# Use an existing keypair
keypair = Nostr::KeyPair.new(
  private_key: Nostr::PrivateKey.new('67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'),
  public_key: Nostr::PublicKey.new('7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'),
)

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
  id: '030fbc71151379e5b58e7428ed6e7f2884e5dfc9087fd64d1dc4cc677f5097c8',
  pubkey: '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e', # from the keypair
  created_at: 1700119819,
  kind: 1, # Nostr::EventKind::TEXT_NOTE,
  tags: [],
  content: 'Your feedback is appreciated, now pay $8',
  sig: '586877896ef6f7d54fa4dd2ade04e3fdc4dfcd6166dd0df696b3c3c768868c0b690338f5baed6ab4fc717785333cb487363384de9fb0f740ac4775522cb4acb3' # signed with the private key from the keypair
}
```
:::
