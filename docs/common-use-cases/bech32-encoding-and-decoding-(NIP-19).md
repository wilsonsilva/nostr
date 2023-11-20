# Encoding/decoding bech-32 strings (NIP-19)

[NIP-19](https://github.com/nostr-protocol/nips/blob/master/19.md) standardizes bech32-formatted strings that can be
used to display keys, ids and other information in clients. These formats are not meant to be used anywhere in the core
protocol, they are only meant for displaying to users, copy-pasting, sharing, rendering QR codes and inputting data.


In order to guarantee the deterministic nature of the documentation, the examples below assume that there is a `keypair`
variable with the following values:

```ruby
keypair = Nostr::KeyPair.new(
  private_key: Nostr::PrivateKey.new('67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'),
  public_key: Nostr::PublicKey.new('7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'),
)

keypair.private_key # => '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'
keypair.public_key # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
```

## Public key (npub)

### Encoding

```ruby
npub = Nostr::Bech32.npub_encode('7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e')
npub # => 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'
```

### Decoding

```ruby
type, public_key = Nostr::Bech32.decode('npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg')
type # => 'npub'
public_key # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
```

## Private key (nsec)

### Encoding

```ruby
nsec = Nostr::Bech32.nsec_encode('67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa')
nsec # => 'nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5'
```

### Decoding

```ruby
type, private_key = Nostr::Bech32.decode('nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5')
type # => 'npub'
private_key # => '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'
```

## Relay (nrelay)

### Encoding

```ruby
nrelay = Nostr::Bech32.nrelay_encode('wss://relay.damus.io')
nrelay # => 'nrelay1qq28wumn8ghj7un9d3shjtnyv9kh2uewd9hsc5zt2x'
```

### Decoding

```ruby
type, data = Nostr::Bech32.decode('nrelay1qq28wumn8ghj7un9d3shjtnyv9kh2uewd9hsc5zt2x')

type # => 'nrelay'
data.entries.first.label # => 'relay'
data.entries.first.value # => 'wss://relay.damus.io'
```

## Event (nevent)

### Encoding

```ruby{8-12}
user = Nostr::User.new(keypair: keypair)
text_note_event = user.create_event(
  kind: Nostr::EventKind::TEXT_NOTE,
  created_at: 1700467997,
  content: 'Your feedback is appreciated, now pay $8'
)

nevent = Nostr::Bech32.nevent_encode(
  id: text_note_event.id,
  relays: ['wss://relay.damus.io', 'wss://nos.lol'],
  kind: Nostr::EventKind::TEXT_NOTE,
)

nevent # => 'nevent1qgsqlkuslr3rf56qpmd0m5ndfyl39m7q6l0zcmuly8ue0praxwkjagcpz3mhxue69uhhyetvv9ujuerpd46hxtnfduqs6amnwvaz7tmwdaejumr0dspsgqqqqqqs03k8v3'
```

### Decoding

```ruby
type, event = Nostr::Bech32.decode('nevent1qgsqlkuslr3rf56qpmd0m5ndfyl39m7q6l0zcmuly8ue0praxwkjagcpz3mhxue69uhhyetvv9ujuerpd46hxtnfduqs6amnwvaz7tmwdaejumr0dspsgqqqqqqs03k8v3')

type # => 'nevent'
event.entries[0].label # => 'author'
event.entries[0].value # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
event.entries[1].relay # => 'relay'
event.entries[1].value # => 'wss://relay.damus.io'
event.entries[2].label # => 'relay'
event.entries[2].value # => 'wss://nos.lol'
event.entries[3].label # => 'kind'
event.entries[3].value # => 1
```

## Address (naddr)

### Encoding

```ruby
naddr = Nostr::Bech32.naddr_encode(
  pubkey: keypair.public_key,
  relays: ['wss://relay.damus.io', 'wss://nos.lol'],
  kind: Nostr::EventKind::TEXT_NOTE,
  identifier: 'damus',
)

naddr # => 'naddr1qgs8ul5ug253hlh3n75jne0a5xmjur4urfxpzst88cnegg6ds6ka7nspz3mhxue69uhhyetvv9ujuerpd46hxtnfduqs6amnwvaz7tmwdaejumr0dspsgqqqqqqsqptyv9kh2uc3qfs2p'
```

### Decoding

```ruby
type, addr = Nostr::Bech32.decode('naddr1qgs8ul5ug253hlh3n75jne0a5xmjur4urfxpzst88cnegg6ds6ka7nspz3mhxue69uhhyetvv9ujuerpd46hxtnfduqs6amnwvaz7tmwdaejumr0dspsgqqqqqqsqptyv9kh2uc3qfs2p')

type # => 'naddr'
addr.entries[0].label # => 'author'
addr.entries[0].value # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
addr.entries[1].label # => 'relay'
addr.entries[1].value # => 'wss://relay.damus.io'
addr.entries[2].label # => 'relay'
addr.entries[2].value # => 'wss://nos.lol'
addr.entries[3].label # => 'kind'
addr.entries[3].value # => 1
addr.entries[4].label # => 'identifier'
addr.entries[4].value # => 'damus'
```

## Profile (nprofile)

### Encoding
```ruby
relay_urls = %w[wss://relay.damus.io wss://nos.lol]
nprofile = Nostr::Bech32.nprofile_encode(pubkey: keypair.public_key, relays: relay_urls)

nprofile # => nprofile1qqs8ul5ug253hlh3n75jne0a5xmjur4urfxpzst88cnegg6ds6ka7nspz3mhxue69uhhyetvv9ujuerpd46hxtnfduqs6amnwvaz7tmwdaejumr0dsxe58m5
```

### Decoding

```ruby
type, profile = Nostr::Bech32.decode('nprofile1qqs8ul5ug253hlh3n75jne0a5xmjur4urfxpzst88cnegg6ds6ka7nspz3mhxue69uhhyetvv9ujuerpd46hxtnfduqs6amnwvaz7tmwdaejumr0dsxe58m5')

type # => 'nprofile'
profile.entries[0].label # => 'pubkey'
profile.entries[0].value # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
profile.entries[1].label # => 'relay'
profile.entries[1].value # => 'wss://relay.damus.io'
profile.entries[2].label # => 'relay'
profile.entries[2].value # => 'wss://nos.lol'
```

## Other simple types (note)

### Encoding

```ruby{8-9}
user = Nostr::User.new(keypair: keypair)
text_note_event = user.create_event(
  kind: Nostr::EventKind::TEXT_NOTE,
  created_at: 1700467997,
  content: 'Your feedback is appreciated, now pay $8'
)

note = Nostr::Bech32.encode(hrp: 'note', data: text_note_event.id)
note # => 'note10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qnx3ujq'
```

### Decoding

```ruby
type, note = Nostr::Bech32.decode('note1pldep78zxnf5qrk6lhfx6jflzthup47793he7g0ej7z86vad963s42v0rr')
type # => 'note'
note # => '0fdb90f8e234d3400edafdd26d493f12efc0d7de2c6f9f21f997847d33ad2ea3'
```
