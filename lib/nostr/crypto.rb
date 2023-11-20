# frozen_string_literal: true

module Nostr
  # Performs cryptographic operations on a +Nostr::Event+.
  class Crypto
    # Numeric base of the OpenSSL big number used in an event content's encryption.
    #
    # @return [Integer]
    #
    BN_BASE = 16

    # Name of the cipher curve used in an event content's encryption.
    #
    # @return [String]
    #
    CIPHER_CURVE = 'secp256k1'

    # Name of the cipher algorithm used in an event content's encryption.
    #
    # @return [String]
    #
    CIPHER_ALGORITHM = 'aes-256-cbc'

    # Encrypts a piece of text
    #
    # @api public
    #
    # @example Encrypting an event's content
    #   crypto = Nostr::Crypto.new
    #   encrypted = crypto.encrypt_text(sender_private_key, recipient_public_key, 'Feedback appreciated. Now pay $8')
    #   encrypted # => "wrYQaHDfpOEvyJELSCg1vzsywmlJTz8NqH03eFW44s8iQs869jtSb26Lr4s23gmY?iv=v38vAJ3LlJAGZxbmWU4qAg=="
    #
    # @param sender_private_key [PrivateKey] 32-bytes hex-encoded private key of the creator.
    # @param recipient_public_key [PublicKey] 32-bytes hex-encoded public key of the recipient.
    # @param plain_text [String] The text to be encrypted
    #
    # @return [String] Encrypted text.
    #
    def encrypt_text(sender_private_key, recipient_public_key, plain_text)
      cipher = OpenSSL::Cipher.new(CIPHER_ALGORITHM).encrypt
      cipher.iv = iv = cipher.random_iv
      cipher.key = compute_shared_key(sender_private_key, recipient_public_key)
      encrypted_text = cipher.update(plain_text) + cipher.final
      encrypted_text = "#{Base64.encode64(encrypted_text)}?iv=#{Base64.encode64(iv)}"
      encrypted_text.gsub("\n", '')
    end

    # Decrypts a piece of text
    #
    # @api public
    #
    # @example Encrypting an event's content
    #   crypto = Nostr::Crypto.new
    #   encrypted # => "wrYQaHDfpOEvyJELSCg1vzsywmlJTz8NqH03eFW44s8iQs869jtSb26Lr4s23gmY?iv=v38vAJ3LlJAGZxbmWU4qAg=="
    #   decrypted = crypto.decrypt_text(recipient_private_key, sender_public_key, encrypted)
    #
    # @param sender_public_key [PublicKey] 32-bytes hex-encoded public key of the message creator.
    # @param recipient_private_key [PrivateKey] 32-bytes hex-encoded public key of the recipient.
    # @param encrypted_text [String] The text to be decrypted
    #
    # @return [String] Decrypted text.
    #
    def decrypt_text(recipient_private_key, sender_public_key, encrypted_text)
      base64_encoded_text, iv = encrypted_text.split('?iv=')

      # Ensure iv and base64_encoded_text are not nil
      return '' unless iv && base64_encoded_text

      cipher = OpenSSL::Cipher.new(CIPHER_ALGORITHM).decrypt
      cipher.iv = Base64.decode64(iv)
      cipher.key = compute_shared_key(recipient_private_key, sender_public_key)
      plain_text = cipher.update(Base64.decode64(base64_encoded_text)) + cipher.final
      plain_text.force_encoding('UTF-8')
    end

    # Uses the private key to generate an event id and sign the event
    #
    # @api public
    #
    # @example Signing an event
    #   crypto = Nostr::Crypto.new
    #   crypto.sign(event, private_key)
    #   event.id # => an id
    #   event.sig # => a signature
    #
    # @param event [Event] The event to be signed
    # @param private_key [PrivateKey] 32-bytes hex-encoded private key.
    #
    # @return [Event] An unsigned event.
    #
    def sign_event(event, private_key)
      event_digest = hash_event(event)

      hex_private_key = Array(private_key).pack('H*')
      hex_message     = Array(event_digest).pack('H*')
      event_signature = Schnorr.sign(hex_message, hex_private_key).encode.unpack1('H*')

      event.id = event_digest
      event.sig = event_signature

      event
    end

    private

    # Finds a shared key between two keys
    #
    # @api private
    #
    # @param private_key [PrivateKey] 32-bytes hex-encoded private key.
    # @param public_key [PublicKey] 32-bytes hex-encoded public key.
    #
    # @return [String] A shared key used in the event's content encryption and decryption.
    #
    def compute_shared_key(private_key, public_key)
      group = OpenSSL::PKey::EC::Group.new(CIPHER_CURVE)

      private_key_bn   = OpenSSL::BN.new(private_key, BN_BASE)
      public_key_bn    = OpenSSL::BN.new("02#{public_key}", BN_BASE)
      public_key_point = OpenSSL::PKey::EC::Point.new(group, public_key_bn)

      asn1 = OpenSSL::ASN1::Sequence(
        [
          OpenSSL::ASN1::Integer.new(1),
          OpenSSL::ASN1::OctetString(private_key_bn.to_s(2)),
          OpenSSL::ASN1::ObjectId(CIPHER_CURVE, 0, :EXPLICIT),
          OpenSSL::ASN1::BitString(public_key_point.to_octet_string(:uncompressed), 1, :EXPLICIT)
        ]
      )

      pkey = OpenSSL::PKey::EC.new(asn1.to_der)
      pkey.dh_compute_key(public_key_point)
    end

    # Generates a SHA256 hash of a +Nostr::Event+
    #
    # @api private
    #
    # @param event [Event] The event to be hashed
    #
    # @return [String] A SHA256 digest of the event
    #
    def hash_event(event)
      Digest::SHA256.hexdigest(JSON.dump(event.serialize))
    end
  end
end
