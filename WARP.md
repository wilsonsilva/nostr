# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Development Commands

### Setup and Installation
```bash
# Initial setup after cloning
bin/setup

# Install gem locally for testing
bundle exec rake install

# Install gem locally without network access
bundle exec rake install:local

# Interactive console for experimentation
bin/console
```

### Testing
```bash
# Run all tests
rake spec
# or
bundle exec rspec

# Run single test file
bundle exec rspec spec/nostr/client_spec.rb

# Run specific test by line number
bundle exec rspec spec/nostr/client_spec.rb:25

# Run tests with coverage report
rake coverage
# This will automatically open coverage/index.html in your browser

# Run QA suite (tests, linting, security audit, documentation checks)
rake qa
```

### Code Quality and Documentation
```bash
# Run RuboCop linting
rake rubocop

# Auto-fix safe RuboCop offenses
rake rubocop:autocorrect

# Auto-fix all RuboCop offenses (including unsafe)
rake rubocop:autocorrect_all

# Generate YARD documentation
rake yard

# Check documentation quality
rake yard:junk
rake verify_measurements

# Type checking with Steep
bundle exec steep check

# Generate RBS type definitions
bundle exec typeprof FILENAME
```

### Security and Dependencies
```bash
# Check for security vulnerabilities in dependencies
rake bundle:audit:check

# Update vulnerability database
rake bundle:audit:update
```

### Building and Releasing
```bash
# Build gem package
rake build

# Generate checksum for built gem
rake build:checksum

# Release new version (creates tag, builds, pushes to RubyGems)
rake release
```

## Architecture Overview

This is an **asynchronous Nostr client** implementation for Ruby that follows the Nostr protocol specifications.

### Core Components

**Client (`Nostr::Client`)**
- Main entry point for interacting with Nostr relays
- Handles WebSocket connections asynchronously using EventMachine
- Implements event-driven architecture with EventEmitter pattern
- Manages subscriptions and publishes events to relays
- Uses multi-threading with channels for parent-child communication

**Event System (`Nostr::Event`)**
- Immutable events are the only data structure in Nostr
- Each event has: id, signature, public key, timestamp, kind, tags, content
- Events are signed with Schnorr signatures using secp256k1 curve
- Supports event references (e-tags) and pubkey references (p-tags)

**User and Key Management**
- `Nostr::User` - Represents a user with a keypair, creates and signs events
- `Nostr::KeyPair` - Contains private/public key pair
- `Nostr::Keygen` - Generates new keypairs or derives from private keys
- Keys use 32-byte hex encoding following Schnorr signature standards

**Cryptography (`Nostr::Crypto`)**
- Handles all cryptographic operations (signing, verification)
- Implements Schnorr signatures for secp256k1 curve
- Manages event ID generation (SHA256 of serialized event data)

**Protocol Implementation**
- `Nostr::Relay` - Represents a Nostr relay connection
- `Nostr::Filter` - Defines subscription filters for events
- `Nostr::Subscription` - Manages active subscriptions to relays
- Implements NIPs (Nostr Implementation Possibilities): NIP-01, NIP-02, NIP-04, NIP-19

### Key Patterns

**Asynchronous Design**
- Uses EventMachine for non-blocking WebSocket connections
- Event-driven callbacks for connection events (connect, message, error, close)
- Background thread execution with channel-based communication

**Immutable Events**
- Events cannot be modified once created
- Event signing creates cryptographic proof of authorship
- Event IDs are deterministic based on content

**Type Safety**
- Fully typed with RBS definitions
- Type checking available via Steep
- Comprehensive YARD documentation with 100% coverage requirement

### Dependencies
- `bech32` - For NIP-19 bech32 encoding
- `bip-schnorr` - Schnorr signature implementation  
- `ecdsa` - Elliptic curve operations
- `event_emitter` - Event-driven programming support
- `faye-websocket` - WebSocket client implementation
- `json` - JSON serialization

The codebase emphasizes **asynchronous operation**, **cryptographic security**, and **full Nostr protocol compliance** while maintaining Ruby idioms and comprehensive testing.
