# String

There's some syntactic sugar for converting between hex and bech32 keys. Using the `Nostr::CoreExt::String` module,
which refines the `String` class, you can call `to_hex` and `to_npub`/`to_nsec` on strings.

This feature is not enabled by default, so you'll need to require it explicitly:

```ruby
require 'nostr/core_ext/string'

using Nostr::CoreExt::String

npub_key = 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'
npub_key.to_hex # => '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'

nsec_key = 'nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5'
nsec_key.to_hex # => '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'

hex_key = '7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'
hex_key.to_npub # => 'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'

hex_key = '67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'
hex_key.to_nsec # => 'nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5'

'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg'.to_key
'nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5'.to_key
```
