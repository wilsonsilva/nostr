# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.1.1/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.6.0] 2024-03-15

### Added

- Added Architecture Decision Records (ADRs) to document architectural decisions
- Added the `Signature` class to fix the primitive obsession with signatures and to make it easier to work with them
- Added `valid_sig?` and `check_sig!` to the `Crypto` class to verify whether an event's signature is valid
- Added `sign_message` to the `Crypto` class to sign a message
- Added `verify_signature?` to the `Event` class to verify whether an event's signature is valid
- Added `#to_ary` to the `KeyPair` class to enable keypair destructuring
- Added RBS types for `schnorr`

### Changed

- Updated the required Ruby version to `3.3.0` (was `3.2.0`)
- Updated the gem `dotenv` to version `3.1` (was `2.8`)
- Updated the gem `bip-schnorr` to version `0.7` (was `0.6`)
- Updated the gem `overcommit` to version `0.63` (was `0.59`)
- Updated the gem `rbs` to version `3.4` (was `3.3`)
- Updated the gem `rspec` to version `3.13` (was `3.12`)
- Updated the gem `rspec-rubocop` to version `2.27` (was `2.25`)
- Updated the gem `rubocop` to version `1.62` (was `1.57`)

### Fixed

- Fixed a typo in the README (`generate_keypair` -> `generate_key_pair`)
- Fixed a typo in the YARD documentation of `Nostr::Key#initialize` (`ValidationError` -> `KeyValidationError`)
- Fixed YARD example rendering issues in `InvalidKeyFormatError#initialize`, `InvalidKeyLengthError#initialize`,
`InvalidKeyTypeError#initialize`, `Event#initialize`, `EncryptedDirectMessage#initialize` and `Filter#to_h`

## [0.5.0] 2023-11-20

### Added

- Added relay message type enums `Nostr::RelayMessageType`
- Compliance with [NIP-19](https://github.com/nostr-protocol/nips/blob/master/19.md) - bech32-formatted strings
- Added `Nostr::PrivateKey` and `Nostr::PublicKey` to represent private and public keys, respectively
- Added a validation of private and public keys
- Added an ability to convert keys to and from Bech32 format
- Added RBS types for `faye-websocket` and `bech32`

### Changed

- Set the gem's homepage to [`https://nostr-ruby.com/`](https://nostr-ruby.com/)
- Updated the filter's documentation to reflect the removal of prefix matching
- Updated the subscription's id documentation to reflect the changes in the protocol definition
- Updated `Nostr::PrivateKey` and `Nostr::PublicKey` internally, instead of Strings
- Updated the gem `bip-schnorr` to version `0.6` (was `0.4`)
- Updated the gem `puma` to version `6.4` (was `6.3`)
- Updated the gem `rake` to version `13.1` (was `13.0`)
- Updated the gem `rbs` to version `3.3` (was `2.8`)
- Updated the gem `rubocop` to version `1.57` (was `1.42`)
- Updated the gem `rubocop-rspec` to version `2.25` (was `2.16`)
- Updated the gem `steep` to version `1.6` (was `1.4`)

## Fixed

- Fixed the RBS type of the constant `Nostr::Crypto::BN_BASE`
- Fixed the return type of `Nostr::Crypto#decrypt_text` when given an invalid ciphertext
- Fixed the RBS type of `Nostr::Filter#to_h`, `Nostr::Filter#e` and `Nostr::Filter#p`
- Fixed the RBS types of `EventEmitter` and `EventMachine::Channel`
- Fixed the generation of private keys

## [0.4.0] - 2023-02-25

### Removed

- Removed `EventFragment` class. The `Event` class is no longer a Value Object. In other words, it is no longer
immutable and it may be invalid by not having attributes `id` or `sig`. The `EventFragment` abstraction, along with the
principles of immutability and was a major source of internal complexity as I needed to scale the codebase.

### Added

- Client compliance with [NIP-04](https://github.com/nostr-protocol/nips/blob/master/04.md) (encrypted direct messages)
- Extracted the cryptographic concerns into a `Crypto` class.
- Added the setters `Event#id=` and `Event#sig=`
- Added a method on the event class to sign events (`Event#sign`)
- Added a missing test for `EventKind::CONTACT_LIST`
- Added two convenience methods to append event and pubkey references to an event's tags `add_event_reference` and
`add_pubkey_reference`

### Fixed

- Fixed the generation of public keys
- Fixed the RBS signature of `User#create_event`

## [0.3.0] - 2023-02-15

### Added

- Client compliance wth [NIP-02](https://github.com/nostr-protocol/nips/blob/master/02.md) (manage contact lists)
- RBS type checking using Steep and TypeProf

## Fixed

- Fixed a documentation typo
- Fixed a documentation error regarding the receiving of messages via websockets

## [0.2.0] - 2023-01-12

### Added

- [NIP-01](https://github.com/nostr-protocol/nips/blob/master/01.md) compliant client

## [0.1.0] - 2023-01-06

- Initial release

[0.6.0]: https://github.com/wilsonsilva/nostr/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/wilsonsilva/nostr/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/wilsonsilva/nostr/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/wilsonsilva/nostr/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/wilsonsilva/nostr/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/wilsonsilva/nostr/compare/7fded5...v0.1.0
