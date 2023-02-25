# Nostr

[![Gem Version](https://badge.fury.io/rb/nostr.svg)](https://badge.fury.io/rb/nostr)
[![Maintainability](https://api.codeclimate.com/v1/badges/c7633eb2c89eb95ee7f2/maintainability)](https://codeclimate.com/github/wilsonsilva/nostr/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c7633eb2c89eb95ee7f2/test_coverage)](https://codeclimate.com/github/wilsonsilva/nostr/test_coverage)

Asynchronous Nostr client. Please note that the API is likely to change as the gem is still in development and
has not yet reached a stable release. Use with caution.

## Table of contents

- [Installation](#installation)
- [Usage](#usage)
  * [Requiring the gem](#requiring-the-gem)
  * [Generating a keypair](#generating-a-keypair)
  * [Generating a private key and a public key](#generating-a-private-key-and-a-public-key)
  * [Connecting to a Relay](#connecting-to-a-relay)
  * [WebSocket events](#websocket-events)
  * [Requesting for events / creating a subscription](#requesting-for-events--creating-a-subscription)
  * [Stop previous subscriptions](#stop-previous-subscriptions)
  * [Publishing an event](#publishing-an-event)
  * [Creating/updating your contact list](#creatingupdating-your-contact-list)
  * [Sending an encrypted direct message](#sending-an-encrypted-direct-message)
- [Implemented NIPs](#implemented-nips)
- [Development](#development)
  * [Type checking](#type-checking)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add nostr

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install nostr

## Usage

### Requiring the gem

All examples below assume that the gem has been required.

```ruby
require 'nostr'
```

### Generating a keypair

```ruby
keygen  = Nostr::Keygen.new
keypair = keygen.generate_key_pair

keypair.private_key
keypair.public_key
```

### Generating a private key and a public key

```ruby
keygen  = Nostr::Keygen.new

private_key = keygen.generate_private_key
public_key  = keygen.extract_public_key(private_key)
```

### Connecting to a Relay

Clients can connect to multiple Relays. In this version, a Client can only connect to a single Relay at a time.

You may instantiate multiple Clients and multiple Relays.

```ruby
client = Nostr::Client.new
relay  = Nostr::Relay.new(url: 'wss://relay.damus.io', name: 'Damus')

client.connect(relay)
```

### WebSocket events

All communication between clients and relays happen in WebSockets.

The `:connect` event is fired when a connection with a WebSocket is opened. You must call `Nostr::Client#connect` first.

```ruby
client.on :connect do
  # all the code goes here
end
```

The `:close` event is fired when a connection with a WebSocket has been closed because of an error.

```ruby
client.on :error do |error_message|
  puts error_message
end

# > Network error: wss://rsslay.fiatjaf.com: Unable to verify the server certificate for 'rsslay.fiatjaf.com'
```

The `:message` event is fired when data is received through a WebSocket.

```ruby
client.on :message do |message|
  puts message
end

# [
#   "EVENT",
#   "d34107357089bfc9882146d3bfab0386",
#   {
#     "content":"",
#     "created_at":1676456512,
#     "id":"18f63550da74454c5df7caa2a349edc5b2a6175ea4c5367fa4b4212781e5b310",
#     "kind":3,
#     "pubkey":"117a121fa41dc2caa0b3d6c5b9f42f90d114f1301d39f9ee96b646ebfee75e36",
#     "sig":"d171420bd62cf981e8f86f2dd8f8f86737ea2bbe2d98da88db092991d125535860d982139a3c4be39886188613a9912ef380be017686a0a8b74231dc6e0b03cb",
#     "tags":[
#       ["p","1cc821cc2d47191b15fcfc0f73afed39a86ac6fb34fbfa7993ee3e0f0186ef7c"]
#     ]
#   }
# ]
```

The `:close` event is fired when a connection with a WebSocket is closed.

```ruby
client.on :close do |code, reason|
  # you may attempt to reconnect

  client.connect(relay)
end
```

### Requesting for events / creating a subscription

A client can request events and subscribe to new updates after it has established a connection with the Relay.

You may use a `Nostr::Filter` instance with as many attributes as you wish:

```ruby
client.on :connect do
  filter = Nostr::Filter.new(
    ids: ['8535d5e2d7b9dc07567f676fbe70428133c9884857e1915f5b1cc6514c2fdff8'],
    authors: ['ae00f88a885ce76afad5cbb2459ef0dcf0df0907adc6e4dac16e1bfbd7074577'],
    kinds: [Nostr::EventKind::TEXT_NOTE],
    e: ["f111593a72cc52a7f0978de5ecf29b4653d0cf539f1fa50d2168fc1dc8280e52"],
    p: ["f1f9b0996d4ff1bf75e79e4cc8577c89eb633e68415c7faf74cf17a07bf80bd8"],
    since: 1230981305,
    until: 1292190341,
    limit: 420,
  )

  subscription = client.subscribe('a_random_subscription_id', filter)
end
```

With just a few:

```ruby
client.on :connect do
  filter = Nostr::Filter.new(kinds: [Nostr::EventKind::TEXT_NOTE])
  subscription = client.subscribe('a_random_subscription_id', filter)
end
```

Or omit the filter:

```ruby
client.on :connect do
  subscription = client.subscribe('a_random_subscription_id')
end
```

Or even omit the subscription id:

```ruby
client.on :connect do
  subscription = client.subscribe('a_random_subscription_id')
end
```

### Stop previous subscriptions

You can stop receiving messages from a subscription by calling `#unsubscribe`:

```ruby
client.unsubscribe('your_subscription_id')
```

### Publishing an event

To publish an event you need a keypair.

```ruby
# Set up the private key
private_key = 'a630b06e2f883378d0aa335b9adaf7734603e00433350b684fe53e184f08c58f'
user = Nostr::User.new(private_key)

# Create a signed event
event = user.create_event(
  created_at: 1667422587, # optional, defaults to the current time
  kind: Nostr::EventKind::TEXT_NOTE,
  tags: [], # optional, defaults to []
  content: 'Your feedback is appreciated, now pay $8'
)

# Send it to the Relay
client.publish(event)
```

### Creating/updating your contact list

Every new contact list that gets published overwrites the past ones, so it should contain all entries.

```ruby
# Creating a contact list event with 2 contacts
update_contacts_event = user.create_event(
  kind: Nostr::EventKind::CONTACT_LIST,
  tags: [
    [
      "p", # mandatory
      "32e1827635450ebb3c5a7d12c1f8e7b2b514439ac10a67eef3d9fd9c5c68e245", # public key of the user to add to the contacts
      "wss://alicerelay.com/", # can be an empty string or can be omitted
      "alice" # can be an empty string or can be omitted
    ],
    [
      "p", # mandatory
      "3efdaebb1d8923ebd99c9e7ace3b4194ab45512e2be79c1b7d68d9243e0d2681", # public key of the user to add to the contacts
      "wss://bobrelay.com/nostr", # can be an empty string or can be omitted
      "bob" # can be an empty string or can be omitted
    ],
  ],
)

# Send it to the Relay
client.publish(update_contacts_event)
```

### Sending an encrypted direct message

```ruby
sender_private_key = '3185a47e3802f956ca5a2b4ea606c1d51c7610f239617e8f0f218d55bdf2b757'

encrypted_direct_message = Nostr::Events::EncryptedDirectMessage.new(
   sender_private_key: sender_private_key,
   recipient_public_key: '6c31422248998e300a1a457167565da7d15d0da96651296ee2791c29c11b6aa0',
   plain_text: 'Your feedback is appreciated, now pay $8',
   previous_direct_message: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460' # optional
)

encrypted_direct_message.sign(sender_private_key)

# #<Nostr::Events::EncryptedDirectMessage:0x0000000104c9fa68
# @content="mjIFNo1sSP3KROE6QqhWnPSGAZRCuK7Np9X+88HSVSwwtFyiZ35msmEVoFgRpKx4?iv=YckChfS2oWCGpMt1uQ4GbQ==",
#   @created_at=1676456512,
#   @id="daac98826d5eb29f7c013b6160986c4baf4fe6d4b995df67c1b480fab1839a9b",
#   @kind=4,
#   @pubkey="8a9d69c56e3c691bec8f9565e4dcbe38ae1d88fffeec3ce66b9f47558a3aa8ca",
#   @sig="028bb5f5bab0396e2065000c84a4bcce99e68b1a79bb1b91a84311546f49c5b67570b48d4a328a1827e7a8419d74451347d4f55011a196e71edab31aa3d6bdac",
#   @tags=[["p", "6c31422248998e300a1a457167565da7d15d0da96651296ee2791c29c11b6aa0"], ["e", "ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460"]]>

# Send it to the Relay
client.publish(encrypted_direct_message)
````

## Implemented NIPs

- [x] [NIP-01 - Client](https://github.com/nostr-protocol/nips/blob/master/01.md)
- [x] [NIP-02 - Client](https://github.com/nostr-protocol/nips/blob/master/02.md)

## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

The health and maintainability of the codebase is ensured through a set of
Rake tasks to test, lint and audit the gem for security vulnerabilities and documentation:

```
rake build                    # Build nostr.gem into the pkg directory
rake build:checksum           # Generate SHA512 checksum if nostr.gem into the checksums directory
rake bundle:audit:check       # Checks the Gemfile.lock for insecure dependencies
rake bundle:audit:update      # Updates the bundler-audit vulnerability database
rake clean                    # Remove any temporary products
rake clobber                  # Remove any generated files
rake coverage                 # Run spec with coverage
rake install                  # Build and install nostr.gem into system gems
rake install:local            # Build and install nostr.gem into system gems without network access
rake qa                       # Test, lint and perform security and documentation audits
rake release[remote]          # Create a tag, build and push nostr.gem to rubygems.org
rake rubocop                  # Run RuboCop
rake rubocop:autocorrect      # Autocorrect RuboCop offenses (only when it's safe)
rake rubocop:autocorrect_all  # Autocorrect RuboCop offenses (safe and unsafe)
rake spec                     # Run RSpec code examples
rake verify_measurements      # Verify that yardstick coverage is at least 100%
rake yard                     # Generate YARD Documentation
rake yard:junk                # Check the junk in your YARD Documentation
rake yardstick_measure        # Measure docs in lib/**/*.rb with yardstick
```

### Type checking

This gem leverages [RBS](https://github.com/ruby/rbs), a language to describe the structure of Ruby programs. It is
used to provide type checking and autocompletion in your editor. Run `bundle exec typeprof FILENAME` to generate
an RBS definition for the given Ruby file. And validate all definitions using [Steep](https://github.com/soutaro/steep)
with the command `bundle exec steep check`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wilsonsilva/nostr.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere
to the [code of conduct](https://github.com/wilsonsilva/nostr/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Nostr project's codebases, issue trackers, chat rooms and mailing lists is expected
to follow the [code of conduct](https://github.com/wilsonsilva/nostr/blob/main/CODE_OF_CONDUCT.md).
