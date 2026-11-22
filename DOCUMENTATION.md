# Ruby Documentation Guidelines

This document outlines the comprehensive documentation standards for Ruby projects, based on the best practices demonstrated in professional Ruby gems. These guidelines ensure 100% documentation coverage and maintainable, professional-quality code documentation.

## Table of Contents

- [Documentation Philosophy](#documentation-philosophy)
- [YARD Configuration](#yard-configuration)
- [Basic Documentation Structure](#basic-documentation-structure)
- [API Visibility Tags](#api-visibility-tags)
- [Method Documentation](#method-documentation)
- [Class and Module Documentation](#class-and-module-documentation)
- [Attribute Documentation](#attribute-documentation)
- [Examples](#examples)
- [Parameter and Return Documentation](#parameter-and-return-documentation)
- [Error Documentation](#error-documentation)
- [Constants Documentation](#constants-documentation)
- [Inheritance Documentation](#inheritance-documentation)
- [Quality Enforcement](#quality-enforcement)
- [Best Practices](#best-practices)

## Documentation Philosophy

Every piece of public and private code must be documented. Documentation serves multiple purposes:
- **API Contract**: Clearly defines what methods do and how to use them
- **Maintenance**: Helps future developers (including yourself) understand the code
- **Testing Guide**: Examples serve as additional test cases
- **User Experience**: Enables IDE autocompletion and contextual help

## YARD Configuration

Create a `.yardstick.yml` file in your project root with 100% coverage requirements:

```yaml
threshold: 100
rules:
  ApiTag::Presence:
    enabled: true
  ApiTag::Inclusion:
    enabled: true
  ApiTag::ProtectedMethod:
    enabled: true
  ApiTag::PrivateMethod:
    enabled: true
  ExampleTag:
    enabled: true
  ReturnTag:
    enabled: true
  Summary::Presence:
    enabled: true
  Summary::Length:
    enabled: false
  Summary::Delimiter:
    enabled: true
  Summary::SingleLine:
    enabled: false
```

## Basic Documentation Structure

Every documented element follows this structure:

```ruby
# Brief one-line summary ending with a period
#
# @api public|private
#
# Detailed description (optional)
#
# @example Description of example
#   code_example
#   result # => expected_output
#
# @param name [Type] Description
# @return [Type] Description
# @raise [ExceptionClass] When this exception occurs
#
```

## API Visibility Tags

**REQUIRED**: Every public and private method, class, and module must have an `@api` tag.

### Public API
```ruby
# @api public
```
Use for:
- Public methods intended for external use
- Public classes and modules
- Public attributes and constants

### Private API
```ruby
# @api private
```
Use for:
- Private methods
- Internal implementation details
- Protected methods
- Private attributes

## Method Documentation

### Public Method Example
```ruby
# Generates a pair of private and public keys
#
# @api public
#
# @example
#   keypair = keygen.generate_key_pair
#   keypair # #<Nostr::KeyPair:0x0000000107bd3550
#    @private_key="893c4cc8088924796b41dc788f7e2f746734497010b1a9f005c1faad7074b900",
#    @public_key="2d7661527d573cc8e84f665fa971dd969ba51e2526df00c149ff8e40a58f9558">
#
# @return [KeyPair] An object containing a private key and a public key.
#
def generate_key_pair
  # implementation
end
```

### Private Method Example
```ruby
# Validates the keys
#
# @api private
#
# @param private_key [PrivateKey] 32-bytes hex-encoded private key.
# @param public_key [PublicKey] 32-bytes hex-encoded public key.
#
# @raise ArgumentError when the private key is not a +PrivateKey+
# @raise ArgumentError when the public key is not a +PublicKey+
#
# @return [void]
#
def validate_keys(private_key, public_key)
  # implementation
end
```

### Constructor Documentation
```ruby
# Instantiates a new Event
#
# @api public
#
# @example Instantiating a new event
#   Nostr::Event.new(
#     id: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460',
#     pubkey: '48df4af6e240ac5f7c5de89bf5941b249880be0e87d03685b178ccb1a315f52e',
#     created_at: 1230981305,
#     kind: 1,
#     tags: [],
#     content: 'Your feedback is appreciated, now pay $8',
#     sig: '123ac2923b792ce730b3da34f16155470ab13c8f97f9c53eaeb334f1fb3a5dc9a7f643'
#   )
#
# @param id [String|nil] 32-bytes sha256 of the the serialized event data.
# @param sig [String|nil] 64-bytes signature of the sha256 hash.
# @param pubkey [String] 32-bytes hex-encoded public key of the event creator.
# @param created_at [Integer] Date of the creation. A UNIX timestamp, in seconds.
# @param kind [Integer] The kind of the event. An integer from 0 to 3.
# @param tags [Array<Array>] An array of tags. Each tag is an array of strings.
# @param content [String] Arbitrary string.
#
def initialize(pubkey:, kind:, content:, created_at: Time.now.to_i, tags: [], id: nil, sig: nil)
  # implementation
end
```

### Methods with Keyword Arguments
```ruby
# Instantiates a new Filter
#
# @api public
#
# @example
#   Nostr::Filter.new(
#     ids: ['c24881c305c5cfb7c1168be7e9b0e150'],
#     authors: ['000000001c5c45196786e79f83d21fe801549fdc98e2c26f96dcef068a5dbcd7'],
#     kinds: [0, 1, 2],
#     since: 1230981305,
#     until: 1292190341
#   )
#
# @param kwargs [Hash]
# @option kwargs [Array<String>, nil] ids A list of event ids
# @option kwargs [Array<String>, nil] authors A list of pubkeys
# @option kwargs [Array<Integer>, nil] kinds A list of a kind numbers
# @option kwargs [Integer, nil] since A timestamp, events must be newer than this
# @option kwargs [Integer, nil] until A timestamp, events must be older than this
# @option kwargs [Integer, nil] limit Maximum number of events to be returned
#
def initialize(**kwargs)
  # implementation
end
```

## Class and Module Documentation

### Class Documentation
```ruby
# The only object type that exists in Nostr is an event. Events are immutable.
class Event
  # class body
end
```

### Module Documentation
```ruby
# Performs cryptographic operations.
class Crypto
  # class body
end
```

### Inheritance Documentation
```ruby
# 32-bytes lowercase hex-encoded private key
class PrivateKey < Key
  # class body
end
```

### Namespace Module
```ruby
# Encapsulates all the gem's logic
module Nostr
  # module body
end
```

## Attribute Documentation

### Reader Attributes
```ruby
# 32-bytes hex-encoded public key of the event creator
#
# @api public
#
# @example
#   event.pubkey # => '48df4af6e240ac5f7c5de89bf5941b249880be0e87d03685b178ccb1a315f52e'
#
# @return [String]
#
attr_reader :pubkey
```

### Accessor Attributes
```ruby
# 64-bytes signature of the sha256 hash of the serialized event data
#
# @api public
#
# @example Getting the event signature
#   event.sig # => '058613f8d34c053294cc28b7f9e1f8f0e80fd1ac94fb20f2da6ca514e7360b39'
#
# @example Setting the event signature
#   event.sig = '058613f8d34c053294cc28b7f9e1f8f0e80fd1ac94fb20f2da6ca514e7360b39'
#   event.sig # => '058613f8d34c053294cc28b7f9e1f8f0e80fd1ac94fb20f2da6ca514e7360b39'
#
# @return [String|nil]
#
attr_accessor :sig
```

### Private Attributes
```ruby
# The elliptic curve group. Used to generate public and private keys
#
# @api private
#
# @return [ECDSA::Group]
#
attr_reader :group
```

## Examples

### Multiple Examples
```ruby
# Subscribes to a set of events using a filter
#
# @api public
#
# @example Creating a subscription with no id and no filters
#   subscription = client.subscribe
#
# @example Creating a subscription with an ID
#   subscription = client.subscribe(subscription_id: 'my-subscription')
#
# @example Subscribing to all events created after a certain time
#   subscription = client.subscribe(filter: Nostr::Filter.new(since: 1230981305))
#
# @param subscription_id [String] The subscription id
# @param filter [Filter] A set of attributes representing events of interest
#
# @return [Subscription] The subscription object
#
def subscribe(subscription_id: SecureRandom.hex, filter: Filter.new)
  # implementation
end
```

### Complex Examples
```ruby
# Allows array destructuring of the KeyPair
#
# @api public
#
# @example Implicit usage of `to_ary` for destructuring
#   keypair = Nostr::KeyPair.new(
#     private_key: Nostr::PrivateKey.new('7d1e4219a5e7d8342654c675085bfbdee143f0eb0f0921f5541ef1705a2b407d'),
#     public_key: Nostr::PublicKey.new('15678d8fbc126fa326fac536acd5a6dcb5ef64b3d939abe31d6830cba6cd26d6'),
#   )
#   # The `to_ary` method can be implicitly used for array destructuring:
#   private_key, public_key = keypair
#   # Now `private_key` and `public_key` hold the respective values.
#
# @example Explicit usage of `to_ary`
#   array_representation = keypair.to_ary
#   # array_representation is now an array: [PrivateKey, PublicKey]
#
# @return [Array<PrivateKey, PublicKey>] An array containing the keys in order
#
def to_ary
  # implementation
end
```

## Parameter and Return Documentation

### Parameter Types
```ruby
# @param event [Event] The event to be signed
# @param private_key [PrivateKey] 32-bytes hex-encoded private key
# @param kwargs [Hash] Configuration options
# @param subscription_id [String] The subscription id
# @param filter [Filter, nil] Optional filter for events
# @param items [Array<String>] List of string items
# @param enabled [Boolean] Whether feature is enabled
# @param count [Integer] Number of items
# @param rate [Float] Processing rate
```

### Return Types
```ruby
# @return [Event] A signed event
# @return [String] The generated private key
# @return [Array<Event>] List of matching events
# @return [Hash{String=>Object}] Configuration mapping
# @return [Boolean] True if valid, false otherwise
# @return [void] This method does not return a value
# @return [String, nil] The result or nil if not found
```

### Complex Return Types
```ruby
# @return [Array<PrivateKey, PublicKey>] An array containing the PrivateKey and PublicKey in that order
# @return [Hash{String=>Subscription}] Mapping of subscription IDs to objects
```

## Error Documentation

### Exception Handling
```ruby
# Validates the hex value of the private key
#
# @api private
#
# @param hex_value [String] The private key in hex format
#
# @raise InvalidKeyTypeError when the private key is not a string
# @raise InvalidKeyLengthError when the private key's length is not 64 characters
# @raise InvalidKeyFormatError when the private key is in an invalid format
#
# @return [void]
#
def validate_hex_value(hex_value)
  # implementation
end
```

### Error Class Documentation
```ruby
# Raised when the private key's length is not 64 characters
#
# @api public
#
class InvalidKeyLengthError < KeyValidationError
  # Initializes the error
  #
  # @example
  #   InvalidKeyLengthError.new('private')
  #
  # @param key_kind [String] The kind of key that is invalid (public or private)
  #
  def initialize(key_kind)
    super("Invalid #{key_kind} key length. It should have 64 characters.")
  end
end
```

## Constants Documentation

### Simple Constants
```ruby
# Numeric base of the OpenSSL big number used in an event content's encryption.
#
# @return [Integer]
#
BN_BASE = 16
```

### Complex Constants
```ruby
# The regular expression for hexadecimal lowercase characters
#
# @return [Regexp] The regular expression for hexadecimal lowercase characters
#
FORMAT = /^[a-f0-9]+$/
```

## Inheritance Documentation

### Subclass with Custom Behavior
```ruby
# 64-bytes lowercase hex of the signature of the sha256 hash of the serialized event data,
# which is the same as the "id" field
class Signature < String
  # Custom implementation
end
```

### Module Inclusion
```ruby
# Clients can talk with relays and can subscribe to any set of events using a subscription filters.
#
# There is no sign-up or account creation for a client. Every time a client connects to a relay, it submits its
# subscription filters and the relay streams the "interested events" to the client as long as they are connected.
#
class Client
  include EventEmitter
  
  # class body
end
```

## Quality Enforcement

### Rake Integration
Add to your `Rakefile`:

```ruby
require 'yardstick/rake/measurement'
require 'yardstick/rake/verify'

yardstick_options = YAML.load_file('.yardstick.yml')

Yardstick::Rake::Measurement.new(:yardstick_measure, yardstick_options)
Yardstick::Rake::Verify.new

desc 'Test, lint and perform security and documentation audits'
task qa: %w[spec rubocop yard:junk verify_measurements bundle:audit]
```

### CI Integration
Include documentation verification in your CI pipeline:

```bash
bundle exec rake verify_measurements
```

## Best Practices

### 1. **Always Use @api Tags**
Every method, class, and module must have an `@api public` or `@api private` tag.

### 2. **Provide Meaningful Examples**
Examples should show real usage, not trivial cases:

```ruby
# GOOD
# @example Subscribing to text notes from the last hour
#   filter = Nostr::Filter.new(
#     kinds: [Nostr::EventKind::TEXT_NOTE],
#     since: Time.now.to_i - 3600
#   )
#   subscription = client.subscribe(filter: filter)

# BAD
# @example
#   client.subscribe
```

### 3. **Document All Parameters**
Even obvious parameters should be documented:

```ruby
# @param id [String] The unique identifier
# @param name [String] The human-readable name
```

### 4. **Use Consistent Type Notation**
- `String` not `string`
- `Array<String>` for arrays of strings
- `Hash{String=>Object}` for hash types
- `Boolean` not `bool`
- `Integer` not `int`

### 5. **Document Return Values**
Every method must have a `@return` tag, even if it returns `void`.

### 6. **Cross-Reference Related Methods**
```ruby
# @see #valid_sig?
# @see Crypto#check_sig!
```

### 7. **Use Code Formatting**
Wrap class names and method names in `+` markers:
```ruby
# @raise ArgumentError when the private key is not a +PrivateKey+
```

### 8. **Document Inheritance Clearly**
When a class inherits behavior, mention it:
```ruby
# Base error class for all signature validation errors
class SignatureValidationError < Error; end
```

### 9. **Version Constants**
```ruby
# The version of the gem
VERSION = '0.7.0'
```

### 10. **Multi-line Examples**
For complex examples, use proper formatting:
```ruby
# @example Creating a comprehensive filter
#   filter = Nostr::Filter.new(
#     kinds: [
#       Nostr::EventKind::TEXT_NOTE,
#       Nostr::EventKind::ENCRYPTED_DIRECT_MESSAGE
#     ],
#     since: Time.now.to_i - 3600, # 1 hour ago
#     until: Time.now.to_i,
#     limit: 20,
#   )
```

This documentation standard ensures that your Ruby projects maintain professional-quality documentation that supports both development and maintenance activities while providing excellent IDE integration and user experience.
