# Logging and debugging

The `Nostr::Client` class provides built-in logging functionality to help you debug and monitor client interactions with
relays. By default, the client uses the `ColorLogger`, which logs events in color. However, you can customize the
logging behavior or disable it entirely.

## Disabling logging

To instantiate a client without any logging, simply pass `logger: nil` when creating the client instance:

```ruby
client = Nostr::Client.new(logger: nil)
```

This will disable all logging for the client.

## Formatting the logging

The `Nostr::Client::Logger` class is the base class for logging functionality. It defines the following methods for
logging different events:

- `on_connect(relay)`: Logs when the client connects to a relay.
- `on_message(message)`: Logs a message received from the relay.
- `on_send(message)`: Logs a message sent to the relay.
- `on_error(message)`: Logs an error message.
- `on_close(code, reason)`: Logs when the connection with a relay is closed.

You can create your own logger by subclassing `Nostr::Client::Logger` and overriding these methods to customize the
logging format.

The `Nostr::Client::ColorLogger` is a built-in logger that logs events in color. It uses ANSI escape codes to add color
to the log output. Here's an example of how the ColorLogger formats the log messages:

- Connection: `"\u001b[32m\u001b[1mConnected to the relay\u001b[22m #{relay.name} (#{relay.url})\u001b[0m"`
- Message received: `"\u001b[32m\u001b[1m◄-\u001b[0m #{message}"`
- Message sent: `"\u001b[32m\u001b[1m-►\u001b[0m #{message}"`
- Error: `"\u001b[31m\u001b[1mError: \u001b[22m#{message}\u001b[0m"`
- Connection closed: `"\u001b[31m\u001b[1mConnection closed: \u001b[22m#{reason} (##{code})\u001b[0m"`

## Plain text logging

If you prefer plain text logging without colors, you can use the `Nostr::Client::PlainLogger`. This logger formats the
log messages in a simple, readable format without any ANSI escape codes.

To use the `PlainLogger`, pass it as the `logger` option when creating the client instance:

```ruby
require 'nostr/client/plain_logger'

client = Nostr::Client.new(logger: Nostr::Client::PlainLogger.new)
```

The `PlainLogger` formats the log messages as follows:

- Connection: `"Connected to the relay #{relay.name} (#{relay.url})"`
- Message received: `"◄- #{message}"`
- Message sent: `"-► #{message}"`
- Error: `"Error: #{message}"`
- Connection closed: `"Connection closed: #{reason} (##{code})"`

By using the appropriate logger or creating your own custom logger, you can effectively debug and monitor your Nostr
client's interactions with relays.
