# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.1.1/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Set the gem's homepage to `https://nostr-ruby.com/`

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

[unreleased]: https://github.com/wilsonsilva/nostr/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/wilsonsilva/nostr/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/wilsonsilva/nostr/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/wilsonsilva/nostr/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/wilsonsilva/nostr/compare/7fded5...v0.1.0
