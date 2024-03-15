# Signing and verifying messages

Signing a message in Nostr proves it was sent by the owner of a specific private key.

## Signing a message

To sign a message, you'll need a private key. Here's how to sign a message using a predefined keypair:

```ruby{9}
require 'nostr'

private_key = Nostr::PrivateKey.new('67dea2ed018072d675f5415ecfaed7d2597555e202d85b3d65ea4e58d2d92ffa'),
public_key = Nostr::PublicKey.new('7e7e9c42a91bfef19fa929e5fda1b72e0ebc1a4c1141673e2794234d86addf4e'),

message = 'We did it with security, now we’re going to do it with the economy.' # The message you want to sign

crypto = Nostr::Crypto.new
signature = crypto.sign_message(message, private_key)
signature # => "d7a0aac1fadcddf1aa2949bedfcdf25ce0c1604e648e55d31431fdacbff8e8256f7c2166d98292f80bc5f79105a0b6e8a89236a47d97cf5d0e7cc1ebf34dea5c"
```

## Verifying a signature

To verify a signature, you need the original message, the public key of the signer, and the signature.

```ruby
crypto.valid_sig?(message, public_key, signature) # => true
crypto.check_sig!(message, public_key, signature) # => true
```

When the message was not signed with the private key corresponding to the public key, the `valid_sig?` method will return `false`.

```ruby
other_public_key = Nostr::PublicKey.new('10be96d345ed58d923a734560680f1adfd2b1006c28ac93b8e1b032a9a32c6e9')
crypto.valid_sig?(message, public_key, signature) # => false
```

And when the message was not signed with the private key corresponding to the public key, the `check_sig!` method will raise an error.

```ruby
other_public_key = Nostr::PublicKey.new('10be96d345ed58d923a734560680f1adfd2b1006c28ac93b8e1b032a9a32c6e9')
crypto.check_sig!(message, other_public_key, signature) # => Schnorr::InvalidSignatureError: signature verification failed
```
