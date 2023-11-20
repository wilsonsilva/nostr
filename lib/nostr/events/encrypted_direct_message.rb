# frozen_string_literal: true

module Nostr
  # Classes of event kinds.
  module Events
    # An event whose +content+ is encrypted. It can only be decrypted by the owner of the private key that pairs
    # the event's +pubkey+.
    class EncryptedDirectMessage < Event
      # Instantiates a new encrypted direct message
      #
      # @api public
      #
      # @example Instantiating a new encrypted direct message
      #  Nostr::Events::EncryptedDirectMessage.new(
      #    sender_private_key: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
      #    recipient_public_key: '48df4af6e240ac5f7c5de89bf5941b249880be0e87d03685b178ccb1a315f52e',
      #    plain_text: 'Your feedback is appreciated, now pay $8',
      #  )
      #
      # @example Instantiating a new encrypted direct message that references a previous direct message
      #  Nostr::Events::EncryptedDirectMessage.new(
      #    sender_private_key: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
      #    recipient_public_key: '48df4af6e240ac5f7c5de89bf5941b249880be0e87d03685b178ccb1a315f52e',
      #    plain_text: 'Your feedback is appreciated, now pay $8',
      #    previous_direct_message: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460'
      #  )
      #
      # @param plain_text [String] The +content+ of the encrypted message.
      # @param sender_private_key [PrivateKey] 32-bytes hex-encoded private key of the message's author.
      # @param recipient_public_key [PublicKey] 32-bytes hex-encoded public key of the recipient of the encrypted
      #  message.
      # @param previous_direct_message [String] 32-bytes hex-encoded id identifying the previous message in a
      # conversation or a message we are explicitly replying to (such that contextual, more organized conversations
      # may happen
      #
      def initialize(plain_text:, sender_private_key:, recipient_public_key:, previous_direct_message: nil)
        crypto = Crypto.new
        keygen = Keygen.new

        encrypted_content = crypto.encrypt_text(sender_private_key, recipient_public_key, plain_text)
        sender_public_key = keygen.extract_public_key(sender_private_key)

        super(
          pubkey: sender_public_key,
          kind: Nostr::EventKind::ENCRYPTED_DIRECT_MESSAGE,
          content: encrypted_content,
        )

        add_pubkey_reference(recipient_public_key)
        add_event_reference(previous_direct_message) if previous_direct_message
      end
    end
  end
end
