# frozen_string_literal: true

module Nostr
  class Client
    # Logs connection events, messages sent and received, errors, and connection closures.
    class PlainLogger < Logger
      # Logs connection to a relay
      #
      # @api private
      #
      # @param [Nostr::Relay] relay The relay the client connected to.
      #
      # @return [void]
      #
      def on_connect(relay)
        puts "Connected to the relay #{relay.name} (#{relay.url})"
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
        puts "◄- #{message}"
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
        puts "-► #{message}"
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
        puts "Error: #{message}"
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
        puts "Connection closed: #{reason} (##{code})"
      end
    end
  end
end
