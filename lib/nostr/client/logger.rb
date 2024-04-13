# frozen_string_literal: true

module Nostr
  class Client
    # Logs connection events, messages sent and received, errors, and connection closures.
    class Logger
      # Attaches event handlers to the specified Nostr client for logging purposes
      #
      # @api public
      #
      # @example Attaching the logger to a client
      #   client = Nostr::Client.new
      #   logger = Nostr::Client::Logger.new
      #   logger.attach_to(client)
      #
      #   # Now, actions like connecting, sending messages, receiving messages,
      #   # errors, and closing the connection will be logged to the console.
      #
      # @param [Nostr::Client] client The client to attach logging functionality to.
      #
      # @return [void]
      #
      def attach_to(client)
        logger_instance = self

        client.on(:connect) { |relay| logger_instance.on_connect(relay) }
        client.on(:message) { |message| logger_instance.on_message(message) }
        client.on(:send) { |message| logger_instance.on_send(message) }
        client.on(:error) { |message| logger_instance.on_error(message) }
        client.on(:close) { |code, reason| logger_instance.on_close(code, reason) }
      end

      # Logs connection to a relay
      #
      # @api private
      #
      # @param [Nostr::Relay] relay The relay the client connected to.
      #
      # @return [void]
      #
      def on_connect(relay); end

      # Logs a message received from the relay
      #
      # @api private
      #
      # @param [String] message The message received.
      #
      # @return [void]
      #
      def on_message(message); end

      # Logs a message sent to the relay
      #
      # @api private
      #
      # @param [String] message The message sent.
      #
      # @return [void]
      #
      def on_send(message); end

      # Logs an error message
      #
      # @api private
      #
      # @param [String] message The error message.
      #
      # @return [void]
      #
      def on_error(message); end

      # Logs a closure of connection with a relay
      #
      # @api private
      #
      # @param [String] code The closure code.
      # @param [String] reason The reason for the closure.
      #
      # @return [void]
      #
      def on_close(code, reason); end
    end
  end
end
