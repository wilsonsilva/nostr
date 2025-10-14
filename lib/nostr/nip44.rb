# frozen_string_literal: true

require 'openssl'
require 'base64'
require 'securerandom'

module Nostr
  # Implements NIP-44 version 2 encryption and decryption
  # @see https://github.com/paulmillr/nip44
  class Nip44
    # NIP-44 version
    VERSION = 2

    # Minimum plaintext size in bytes
    MIN_PLAINTEXT_SIZE = 1

    # Maximum plaintext size in bytes (64KB - 1)
    MAX_PLAINTEXT_SIZE = 65_535

    # Minimum padded message size
    MIN_PADDED_SIZE = 32

    # HKDF salt for conversation key derivation
    HKDF_SALT = 'nip44-v2'

    # Size constraints for base64 payload
    MIN_BASE64_SIZE = 132
    MAX_BASE64_SIZE = 87_472

    # Size constraints for decoded payload
    MIN_DECODED_SIZE = 99
    MAX_DECODED_SIZE = 65_603

    # Nonce size in bytes
    NONCE_SIZE = 32

    # MAC size in bytes
    MAC_SIZE = 32

    # Calculates the padded length for a given unpadded length
    #
    # @param unpadded_len [Integer] The length of the unpadded message
    # @return [Integer] The padded length
    def self.calc_padded_len(unpadded_len)
      return MIN_PADDED_SIZE if unpadded_len <= MIN_PADDED_SIZE

      next_power = 1 << (Math.log2(unpadded_len - 1).floor + 1)
      chunk = next_power <= 256 ? 32 : next_power / 8
      chunk * ((unpadded_len - 1) / chunk + 1)
    end

    # Pads plaintext according to NIP-44 specification
    #
    # @param plaintext [String] The plaintext to pad
    # @return [String] Padded plaintext as binary string
    # @raise [ArgumentError] if plaintext length is invalid
    def self.pad(plaintext)
      unpadded = plaintext.encode('UTF-8').bytes
      unpadded_len = unpadded.length

      raise ArgumentError, 'invalid plaintext length' if unpadded_len < MIN_PLAINTEXT_SIZE ||
                                                         unpadded_len > MAX_PLAINTEXT_SIZE

      padded_len = calc_padded_len(unpadded_len)
      prefix = [unpadded_len].pack('n') # Big-endian uint16
      suffix = "\x00" * (padded_len - unpadded_len)

      prefix + unpadded.pack('C*') + suffix
    end

    # Removes padding from padded plaintext
    #
    # @param padded [String] The padded plaintext as binary string
    # @return [String] Unpadded plaintext
    # @raise [ArgumentError] if padding is invalid
    def self.unpad(padded)
      raise ArgumentError, 'invalid padding: too short' if padded.length < 2

      unpadded_len = padded.unpack1('n') # Big-endian uint16
      raise ArgumentError, 'invalid padding: unpadded length exceeds padded size' if unpadded_len > padded.length - 2

      unpadded = padded[2, unpadded_len]

      raise ArgumentError, 'invalid padding: zero length' if unpadded_len.zero?
      raise ArgumentError, 'invalid padding: length mismatch' if unpadded.nil? || unpadded.length != unpadded_len

      expected_padded_len = calc_padded_len(unpadded_len)
      raise ArgumentError, 'invalid padding: total length mismatch' if padded.length != (2 + expected_padded_len)

      unpadded.force_encoding('UTF-8')
    end

    # Decodes the NIP-44 payload
    #
    # @param payload [String] Base64-encoded payload
    # @return [Array<String>] Array containing [nonce, ciphertext, mac]
    # @raise [ArgumentError] if payload format is invalid
    def self.decode_payload(payload)
      plen = payload.length

      raise ArgumentError, 'unknown version' if plen.zero? || payload[0] == '#'
      raise ArgumentError, 'invalid payload size' if plen < MIN_BASE64_SIZE || plen > MAX_BASE64_SIZE

      # Add padding if needed for interoperability with implementations that omit it
      # NIP-44 uses standard base64 (not base64url), so + and / are valid, - and _ are not
      padded_payload = case payload.length % 4
                       when 2 then payload + '=='
                       when 3 then payload + '='
                       else payload
                       end

      data = Base64.strict_decode64(padded_payload)
      dlen = data.length

      raise ArgumentError, 'invalid data size' if dlen < MIN_DECODED_SIZE || dlen > MAX_DECODED_SIZE

      version = data[0].unpack1('C')
      raise ArgumentError, "unknown version #{version}" if version != VERSION

      nonce = data[1, NONCE_SIZE]
      ciphertext = data[(1 + NONCE_SIZE)...(dlen - MAC_SIZE)]
      mac = data[(dlen - MAC_SIZE)..]

      [nonce, ciphertext, mac]
    end

    # Calculates HMAC with additional authenticated data (AAD)
    #
    # @param key [String] HMAC key
    # @param message [String] Message to authenticate
    # @param aad [String] Additional authenticated data (must be 32 bytes)
    # @return [String] HMAC-SHA256 digest
    # @raise [ArgumentError] if AAD is not 32 bytes
    def self.hmac_aad(key, message, aad)
      raise ArgumentError, 'AAD associated data must be 32 bytes' if aad.length != NONCE_SIZE

      OpenSSL::HMAC.digest('SHA256', key, aad + message)
    end

    # Performs HKDF-extract operation
    #
    # @param ikm [String] Input keying material
    # @param salt [String] Salt value
    # @return [String] Pseudorandom key
    def self.hkdf_extract(ikm, salt)
      OpenSSL::HMAC.digest('SHA256', salt, ikm)
    end

    # Performs HKDF-expand operation
    #
    # @param prk [String] Pseudorandom key from extract step
    # @param info [String] Context and application specific information
    # @param length [Integer] Length of output keying material in bytes
    # @return [String] Output keying material
    def self.hkdf_expand(prk, info, length)
      hash_len = 32 # SHA256 output length
      n = (length.to_f / hash_len).ceil
      okm = ''
      prev = ''

      (1..n).each do |i|
        prev = OpenSSL::HMAC.digest('SHA256', prk, prev + info + [i].pack('C'))
        okm += prev
      end

      okm[0, length]
    end

    # Computes the shared secret using ECDH
    #
    # @param private_key_hex [String] Private key as hex string
    # @param public_key_hex [String] Public key as hex string
    # @return [String] Shared secret (32-byte x coordinate)
    def self.secp256k1_ecdh(private_key_hex, public_key_hex)
      group = OpenSSL::PKey::EC::Group.new('secp256k1')

      # Parse private key
      private_key_bn = OpenSSL::BN.new(private_key_hex, 16)
      
      # Parse public key (add 02 prefix for compressed format)
      public_key_bn = OpenSSL::BN.new("02#{public_key_hex}", 16)
      public_key_point = OpenSSL::PKey::EC::Point.new(group, public_key_bn)

      # For OpenSSL 3.0+, we need to use ASN.1 DER encoding to create an immutable key
      # However, we should use the generator point (not the recipient's public key) for the private key structure
      generator = group.generator
      our_public_key = generator.mul(private_key_bn)
      
      asn1 = OpenSSL::ASN1::Sequence([
        OpenSSL::ASN1::Integer.new(1),
        OpenSSL::ASN1::OctetString(private_key_bn.to_s(2)),
        OpenSSL::ASN1::ObjectId('secp256k1', 0, :EXPLICIT),
        OpenSSL::ASN1::BitString(our_public_key.to_octet_string(:uncompressed), 1, :EXPLICIT)
      ])

      pkey = OpenSSL::PKey::EC.new(asn1.to_der)
      
      # Compute shared point and return x coordinate
      shared_point = pkey.dh_compute_key(public_key_point)
      
      # Return the 32-byte x coordinate (first 32 bytes of the shared point)
      shared_point[0, 32]
    end

    # Derives conversation key from private and public keys
    #
    # @param private_key_a [String] Private key A as hex string
    # @param public_key_b [String] Public key B as hex string
    # @return [String] 32-byte conversation key
    def self.get_conversation_key(private_key_a, public_key_b)
      shared_x = secp256k1_ecdh(private_key_a, public_key_b)
      hkdf_extract(shared_x, HKDF_SALT.encode('UTF-8'))
    end

    # Derives message keys from conversation key and nonce
    #
    # @param conversation_key [String] 32-byte conversation key
    # @param nonce [String] 32-byte nonce
    # @return [Array<String>] Array containing [chacha_key, chacha_nonce, hmac_key]
    # @raise [ArgumentError] if key or nonce length is invalid
    def self.get_message_keys(conversation_key, nonce)
      raise ArgumentError, 'invalid conversation_key length' if conversation_key.length != 32
      raise ArgumentError, 'invalid nonce length' if nonce.length != NONCE_SIZE

      keys = hkdf_expand(conversation_key, nonce, 76)
      
      chacha_key = keys[0, 32]
      chacha_nonce = keys[32, 12]
      hmac_key = keys[44, 32]

      [chacha_key, chacha_nonce, hmac_key]
    end

    # Constant-time comparison of two byte strings
    #
    # @param a [String] First string
    # @param b [String] Second string
    # @return [Boolean] True if strings are equal
    def self.secure_compare(a, b)
      return false if a.bytesize != b.bytesize

      l = a.unpack('C*')
      r = b.unpack('C*')
      res = 0
      l.zip(r) { |x, y| res |= x ^ y }
      res.zero?
    end

    # Encrypts plaintext using NIP-44 v2
    #
    # @param plaintext [String] The plaintext message to encrypt
    # @param conversation_key [String] 32-byte conversation key
    # @param nonce [String, nil] 32-byte nonce (auto-generated if nil)
    # @return [String] Base64-encoded encrypted payload
    # @raise [ArgumentError] if plaintext length is invalid
    def self.encrypt(plaintext, conversation_key, nonce = nil)
      nonce ||= SecureRandom.random_bytes(NONCE_SIZE)
      raise ArgumentError, 'invalid nonce length' if nonce.length != NONCE_SIZE

  chacha_key, chacha_nonce, hmac_key = get_message_keys(conversation_key, nonce)

  # Pad the plaintext
  padded = pad(plaintext)

  # OpenSSL expects a 16-byte IV for ChaCha20: [counter (4 bytes)][nonce (12 bytes)]
  # RFC 8439 specifies counter should be 0 for the first block
  iv = "\x00\x00\x00\x00" + chacha_nonce

  cipher = OpenSSL::Cipher.new('chacha20')
  cipher.encrypt
  cipher.key = chacha_key
  cipher.iv = iv
  ciphertext = cipher.update(padded) + cipher.final

  # Calculate MAC
  mac = hmac_aad(hmac_key, ciphertext, nonce)

  # Encode payload: version (1 byte) + nonce (32 bytes) + ciphertext + mac (32 bytes)
  payload = [VERSION].pack('C') + nonce + ciphertext + mac
  Base64.strict_encode64(payload)
    end

    # Decrypts a NIP-44 v2 encrypted payload
    #
    # @param payload [String] Base64-encoded encrypted payload
    # @param conversation_key [String] 32-byte conversation key
    # @return [String] Decrypted plaintext
    # @raise [ArgumentError] if payload format is invalid or MAC verification fails
    def self.decrypt(payload, conversation_key)
      nonce, ciphertext, mac = decode_payload(payload)

  chacha_key, chacha_nonce, hmac_key = get_message_keys(conversation_key, nonce)

  # Verify MAC
  calculated_mac = hmac_aad(hmac_key, ciphertext, nonce)
  raise ArgumentError, 'invalid MAC' unless secure_compare(calculated_mac, mac)

  # OpenSSL expects a 16-byte IV for ChaCha20: [counter (4 bytes)][nonce (12 bytes)]
  # RFC 8439 specifies counter should be 0 for the first block
  iv = "\x00\x00\x00\x00" + chacha_nonce

  cipher = OpenSSL::Cipher.new('chacha20')
  cipher.decrypt
  cipher.key = chacha_key
  cipher.iv = iv
  padded_plaintext = cipher.update(ciphertext) + cipher.final

  # Remove padding
  unpad(padded_plaintext)
    end
  end
end
