# Nostr

[![Gem Version](https://badge.fury.io/rb/nostr.svg)](https://badge.fury.io/rb/nostr)
[![Maintainability](https://api.codeclimate.com/v1/badges/c7633eb2c89eb95ee7f2/maintainability)](https://codeclimate.com/github/wilsonsilva/nostr/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c7633eb2c89eb95ee7f2/test_coverage)](https://codeclimate.com/github/wilsonsilva/nostr/test_coverage)

Asynchronous Nostr client for Rubyists.

## Table of contents

- [Key features](#-key-features)
- [Installation](#-installation)
- [Quickstart](#-quickstart)
- [Documentation](#-documentation)
- [Implemented NIPs](#-implemented-nips)
- [Development](#-development)
  * [Type checking](#type-checking)
- [Contributing](#-contributing)
- [License](#-license)
- [Code of Conduct](#-code-of-conduct)

## 🔑 Key features

- Asynchronous
- Easy to use
- Fully documented
- Fully tested
- Fully typed

## 📦 Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add nostr

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install nostr

## ⚡️ Quickstart

Here is a quick example of how to use the gem. For more detailed documentation, please check the
[documentation website](https://nostr-ruby.com).

```ruby
# Require the gem
require 'nostr'

# Instantiate a client
client = Nostr::Client.new

# a) Use an existing keypair
keypair = Nostr::KeyPair.new(
  private_key: 'add-your-private-key-here',
  public_key: 'add-your-public-key-here',
)

# b) Or create a new keypair
keygen = Nostr::Keygen.new
keypair = keygen.generate_keypair

# Create a user with the keypair
user = Nostr::User.new(keypair: keypair)

# Create a signed event
text_note_event = user.create_event(
  kind: Nostr::EventKind::TEXT_NOTE,
  content: 'Your feedback is appreciated, now pay $8'
)

# Connect asynchronously to a relay
relay = Nostr::Relay.new(url: 'wss://nostr.wine', name: 'Wine')
client.connect(relay)

# Listen asynchronously for the connect event
client.on :connect do
  # Send the event to the Relay
  client.publish(text_note_event)

  # Create a filter to receive the first 20 text notes
  # and encrypted direct messages from the relay that
  # were created in the previous hour
  filter = Nostr::Filter.new(
    kinds: [
      Nostr::EventKind::TEXT_NOTE,
      Nostr::EventKind::ENCRYPTED_DIRECT_MESSAGE
    ],
    since: Time.now.to_i - 3600, # 1 hour ago
    until: Time.now.to_i,
    limit: 20,
  )

  # Subscribe to events matching conditions of a filter
  subscription = client.subscribe(filter)

  # Unsubscribe from events matching the filter above
  client.unsubscribe(subscription.id)
end

# Listen for incoming messages and print them
client.on :message do |message|
  puts message
end

# Listen for error messages
client.on :error do |error_message|
  # Handle the error
end

# Listen for the close event
client.on :close do |code, reason|
  # You may attempt to reconnect to the relay here
end
```

## 📚 Documentation

I made a detailed documentation for this gem and it's usage. The code is also fully documented using YARD.

- [Guide documentation](https://nostr-ruby.com)
- [YARD documentation](https://rubydoc.info/gems/nostr)

## ✅ Implemented NIPs

- [x] [NIP-01 - Client](https://github.com/nostr-protocol/nips/blob/master/01.md)
- [x] [NIP-02 - Client](https://github.com/nostr-protocol/nips/blob/master/02.md)
- [x] [NIP-04 - Client](https://github.com/nostr-protocol/nips/blob/master/04.md)

## 🔨 Development

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

## 🐞 Issues & Bugs

If you find any issues or bugs, please report them [here](https://github.com/wilsonsilva/nostr/issues), I will be happy
to have a look at them and fix them as soon as possible.

## 🤝 Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wilsonsilva/nostr.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere
to the [code of conduct](https://github.com/wilsonsilva/nostr/blob/main/CODE_OF_CONDUCT.md).

## 📜 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 👔 Code of Conduct

Everyone interacting in the Nostr project's codebases, issue trackers, chat rooms and mailing lists is expected
to follow the [code of conduct](https://github.com/wilsonsilva/nostr/blob/main/CODE_OF_CONDUCT.md).
