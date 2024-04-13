# 3. Default Logging Activation

Date: 2024-03-19

## Status

Accepted

## Context

Logging provides visibility into the gem's behavior and helps to diagnose issues. The decision centered on whether
to enable logging by default or require manual activation.

### Option 1: On-demand Logging

```ruby
client = Nostr::Client.new
logger = Nostr::ClientLogger.new
logger.attach_to(client)
```

#### Advantages:

- Offers users flexibility and control over logging.
- Conserves resources by logging only when needed.

#### Disadvantages:

- Potential to miss critical logs if not enabled.
- Requires users to read and understand documentation to enable logging.
- Requires users to manually activate and configure logging.

### Option 2: Automatic Logging

```ruby
class Client
  def initialize(logger: ClientLogger.new)
    @logger = logger
    logger&.attach_to(self)
  end
end

client = Nostr::Client.new
```

#### Advantages:

- Ensures comprehensive logging without user intervention.
- Simplifies debugging and monitoring.
- Balances logging detail with performance impact.

#### Disadvantages:

- Needs additional steps to disable logging.

## Decision

Logging will be enabled by default. Users can disable logging by passing a `nil` logger to the client:

```ruby
client = Nostr::Client.new(logger: nil)
```

## Consequences

Enabling logging by default favors ease of use and simplifies the developer's experience.
