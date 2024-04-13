# frozen_string_literal: true

module Nostr
  class Client
    # Logs connection events, messages sent and received, errors, and connection closures in color.
    class ColorLogger < Logger
      # Logs connection to a relay
      #
      # @api private
      #
      # @param [Nostr::Relay] relay The relay the client connected to.
      #
      # @return [void]
      #
      def on_connect(relay)
        puts "\u001b[32m\u001b[1mConnected to the relay\u001b[22m #{relay.name} (#{relay.url})\u001b[0m"
      end

      # Logs a message received from the relay
      #
      # @api private
      #
      # @param [String] message The message received.
      #
      # @return [void]
      #
      def on_message(message)
        puts "\u001b[32m\u001b[1m◄-\u001b[0m #{message}"
      end

      # Logs a message sent to the relay
      #
      # @api private
      #
      # @param [String] message The message sent.
      #
      # @return [void]
      #
      def on_send(message)
        puts "\u001b[32m\u001b[1m-►\u001b[0m #{message}"
      end

      # Logs an error message
      #
      # @api private
      #
      # @param [String] message The error message.
      #
      # @return [void]
      #
      def on_error(message)
        puts "\u001b[31m\u001b[1mError: \u001b[22m#{message}\u001b[0m"
      end

      # Logs a closure of connection with a relay
      #
      # @api private
      #
      # @param [String] code The closure code.
      # @param [String] reason The reason for the closure.
      #
      # @return [void]
      #
      def on_close(code, reason)
        puts "\u001b[31m\u001b[1mConnection closed: \u001b[22m#{reason} (##{code})\u001b[0m"
      end
    end
  end
end
