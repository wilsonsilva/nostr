# 3. Logging methods vs logger class

Date: 2024-03-19

## Status

Accepted

## Context

I'm deciding between integrating logging directly into the main class or creating a dedicated logger class.

### Option 1: Logging methods

The first approach weaves logging actions into the operational code, resulting in a tight coupling of functionality and
logging. Classes should be open for extension but closed for modification, and this strategy violates that principle.

```ruby
class Client
  def connect(relay)
    execute_within_an_em_thread do
      client = build_websocket_client(relay.url)
      parent_to_child_channel.subscribe do |msg|
        client.send(msg)
        emit(:send, msg)
        log_send(msg) # <------ new code
      end

      client.on :open do
        child_to_parent_channel.push(type: :open, relay:)
        log_connection_opened(relay) # <------ new code
      end

      client.on :message do |event|
        child_to_parent_channel.push(type: :message, data: event.data)
        log_message_received(event.data) # <------ new code
      end

      client.on :error do |event|
        child_to_parent_channel.push(type: :error, message: event.message)
        log_error(event.message) # <------ new code
      end

      client.on :close do |event|
        child_to_parent_channel.push(type: :close, code: event.code, reason: event.reason)
        log_connection_closed(event.code, event.reason) # <------ new code
      end
    end

    # ------ new code below ------

    def log_send(msg)
      logger.info("Message sent: #{msg}")
    end

    def log_connection_opened(relay)
      logger.info("Connection opened to #{relay.url}")
    end

    def log_message_received(data)
      logger.info("Message received: #{data}")
    end

    def log_error(message)
      logger.error("Error: #{message}")
    end

    def log_connection_closed(code, reason)
      logger.info("Connection closed with code: #{code}, reason: #{reason}")
    end
  end
end
```

### Option 2: Logger class

The second strategy separates logging into its own class, promoting cleaner code and adherence to the Single
Responsibility Principle. Client already exposes events that can be tapped into, so the logger class can listen to these
events and log accordingly.

```ruby
class ClientLogger
  def attach_to(client)
    logger_instance = self

    client.on(:connect) { |relay| logger_instance.on_connect(relay) }
    client.on(:message) { |message| logger_instance.on_message(message) }
    client.on(:send) { |message| logger_instance.on_send(message) }
    client.on(:error) { |message| logger_instance.on_error(message) }
    client.on(:close) { |code, reason| logger_instance.on_close(code, reason) }
  end

  def on_connect(relay); end
  def on_message(message); end
  def on_send(message); end
  def on_error(message); end
  def on_close(code, reason); end
end

client = Nostr::Client.new
logger = Nostr::ClientLogger.new
logger.attach_to(client)
```

This approach decouples logging from the main class, making it easier to maintain and extend the logging system without
affecting the core logic.

## Decision

I've chosen the dedicated logger class route. This choice is driven by a desire for extensibility in the logging system.
With a separate logger, I can easily modify logging behavior—like changing formats, adjusting verbosity levels,
switching colors, or altering output destinations (files, networks, etc.) — without needing to rewrite any of the main
operational code.

## Consequences

Adopting a dedicated logger class offers greater flexibility and simplifies maintenance, making it straightforward to
adjust how and what I log independently of the core logic. This separation of concerns means that any future changes
to logging preferences or requirements can be implemented quickly and without risk to the main class's functionality.
However, it's important to manage the integration carefully to avoid introducing complexity, such as handling
dependencies and ensuring seamless communication between the main operations and the logging system.

