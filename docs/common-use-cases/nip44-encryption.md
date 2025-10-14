# NIP-44 Encryption

NIP-44 is a modern, versioned encryption scheme for Nostr that provides authenticated encryption with improved security over the legacy NIP-04 standard.

## Overview

NIP-44 version 2 uses:

- **ECDH** (Elliptic Curve Diffie-Hellman) on secp256k1 for key agreement
- **HKDF** (HMAC-based Key Derivation Function) with SHA-256 for key derivation
- **ChaCha20** for encryption
- **HMAC-SHA256** for message authentication
- Custom padding scheme to obscure message length

This provides authenticated encryption, protecting against tampering and ensuring message integrity.

## Why NIP-44 over NIP-04?

**NIP-04** (legacy):

- Uses unauthenticated AES-256-CBC encryption
- No protection against tampering
- Known security vulnerabilities
- Output format: `base64_ciphertext?iv=base64_iv`

**NIP-44** (recommended):

- Uses authenticated encryption (ChaCha20 + HMAC-SHA256)
- Protects against tampering with MAC verification
- Audited implementation (Cure53, December 2023)
- Output format: Single base64 string with version byte

**For new applications, always use NIP-44.** NIP-04 should only be used for backward compatibility with older clients.

## Usage

### Basic Encryption and Decryption

```ruby
require 'nostr'

# Generate or load your keys
sender_private_key = Nostr::PrivateKey.new('your_private_key_hex')
sender_public_key = Nostr::PublicKey.new('your_public_key_hex')

recipient_private_key = Nostr::PrivateKey.new('recipient_private_key_hex')
recipient_public_key = Nostr::PublicKey.new('recipient_public_key_hex')

# Initialize crypto
crypto = Nostr::Crypto.new

# Sender encrypts a message for recipient
plaintext = "Hello, this is a secret message!"
encrypted = crypto.encrypt_nip44(sender_private_key, recipient_public_key, plaintext)
# => "AgK8... (base64 string)"

# Recipient decrypts the message
decrypted = crypto.decrypt_nip44(recipient_private_key, sender_public_key, encrypted)
# => "Hello, this is a secret message!"
```

### Using the Nip44 Module Directly

For more control, you can use the `Nostr::Nip44` module directly:

```ruby
# Get conversation key (can be reused for multiple messages)
conversation_key = Nostr::Nip44.get_conversation_key(
  sender_private_key.to_s,
  recipient_public_key.to_s
)

# Encrypt (generates a random nonce automatically)
ciphertext = Nostr::Nip44.encrypt(plaintext, conversation_key)

# Decrypt
plaintext = Nostr::Nip44.decrypt(ciphertext, conversation_key)
```

### In Event Content

NIP-44 is typically used to encrypt the content of Nostr events:

```ruby
# Create an encrypted direct message event
sender_keypair = Nostr::KeyPair.new(
  private_key: sender_private_key,
  public_key: sender_public_key
)

# Encrypt the message
crypto = Nostr::Crypto.new
encrypted_content = crypto.encrypt_nip44(
  sender_keypair.private_key,
  recipient_public_key,
  "Secret message"
)

# Create the event (kind 4 for direct messages)
event = Nostr::Event.new(
  kind: Nostr::EventKind::ENCRYPTED_DIRECT_MESSAGE,
  content: encrypted_content,
  pubkey: sender_keypair.public_key,
  tags: [['p', recipient_public_key.to_s]]
)

# Sign the event
crypto.sign_event(event, sender_keypair.private_key)

# Now you can publish the event to relays
```

### Detecting Encryption Type

If you need to handle both NIP-04 and NIP-44 encrypted content:

```ruby
def decrypt_content(private_key, public_key, encrypted_content)
  crypto = Nostr::Crypto.new

  if encrypted_content.include?('?iv=')
    # NIP-04 format
    crypto.decrypt_text(private_key, public_key, encrypted_content)
  else
    # NIP-44 format
    crypto.decrypt_nip44(private_key, public_key, encrypted_content)
  end
end
```

## Security Considerations

### Limitations

NIP-44 has the following known limitations:

- **No deniability**: Messages can be proven to come from a specific key
- **No forward secrecy**: Compromised keys allow decryption of all past messages
- **No post-compromise security**: Compromised keys allow decryption of all future messages
- **No post-quantum security**: Vulnerable to quantum computers
- **Metadata leakage**: Created_at timestamp, message size (partially obscured by padding)

### Best Practices

1. **Use NIP-44 for all new implementations** instead of NIP-04
2. **Never reuse nonces** (handled automatically by the library)
3. **Validate MAC before processing decrypted content** (done automatically)
4. **Use trusted relays** to mitigate lack of forward secrecy
5. **For high-risk communications**, use specialized E2EE messaging software

### Message Size Limits

- **Minimum**: 1 byte
- **Maximum**: 65,535 bytes (64 KB - 1)
- **Padding**: Messages are padded to at least 32 bytes using a power-of-two scheme

## Error Handling

The encryption and decryption methods will raise `ArgumentError` for various error conditions:

```ruby
begin
  decrypted = crypto.decrypt_nip44(private_key, public_key, ciphertext)
rescue ArgumentError => e
  case e.message
  when /invalid MAC/
    # Message was tampered with or wrong keys used
    puts "Message authentication failed"
  when /invalid padding/
    # Corrupted ciphertext
    puts "Message is corrupted"
  when /unknown version/
    # Unsupported NIP-44 version
    puts "Unsupported encryption version"
  when /invalid.*length/
    # Invalid input sizes
    puts "Invalid key or message format"
  else
    # Other errors
    puts "Decryption failed: #{e.message}"
  end
end
```

## Technical Details

### Encryption Process

1. **ECDH**: Compute shared secret from private key A and public key B
2. **HKDF-Extract**: Derive conversation key using salt "nip44-v2"
3. **Generate Nonce**: Create random 32-byte nonce (using CSPRNG)
4. **HKDF-Expand**: Derive ChaCha20 key (32 bytes), ChaCha20 nonce (12 bytes), and HMAC key (32 bytes)
5. **Padding**: Pad plaintext using power-of-two scheme
6. **Encrypt**: Encrypt padded plaintext with ChaCha20
7. **MAC**: Calculate HMAC-SHA256 over (nonce || ciphertext)
8. **Encode**: Concatenate (version || nonce || ciphertext || MAC) and base64 encode

### Decryption Process

1. **Decode**: Base64 decode and extract version, nonce, ciphertext, and MAC
2. **Validate Version**: Ensure version byte is 0x02
3. **ECDH + HKDF**: Derive same keys as encryption
4. **Verify MAC**: Calculate MAC and compare with constant-time algorithm
5. **Decrypt**: Decrypt ciphertext with ChaCha20
6. **Unpad**: Remove padding and validate padding format
7. **Return**: Return UTF-8 plaintext

## References

- [NIP-44 Specification](https://github.com/nostr-protocol/nips/blob/master/44.md)
- [Security Audit (Cure53, December 2023)](https://github.com/paulmillr/nip44/blob/main/audit-2023.12.pdf)
- [Reference Implementation](https://github.com/paulmillr/nip44)

## See Also

- [NIP-04 Encryption (Legacy)](./nip04-encryption.md)
- [Encrypted Direct Messages](../events/encrypted-direct-message.md)
- [Common Use Cases: Signing and Verifying Events](../common-use-cases/signing-and-verifying-events.md)
