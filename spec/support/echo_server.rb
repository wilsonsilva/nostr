# frozen_string_literal: true

require 'puma'
require 'logger'
require 'puma/binder'
require 'puma/events'

class EchoServer
  def call(env)
    @socket = Faye::WebSocket.new(env, ['echo'])

    @socket.onmessage = lambda do |event|
      @socket.send(event.data)
    end

    @socket.rack_response
  end

  def send(message)
    @socket.send(message)
  end

  def close(code, reason)
    @socket.close(code, reason)
  end

  def log(*args); end

  def listen(port)
    # Instead of logging to the stdout/stderr, we'll log to a StringIO to prevent cluttering the test output
    silent_stream = StringIO.new
    logger = Puma::LogWriter.new(silent_stream, silent_stream)
    events = Puma::Events.new
    binder = Puma::Binder.new(logger)
    binder.parse(["tcp://0.0.0.0:#{port}"], logger)

    @server = Puma::Server.new(self, events)
    @server.binder = binder
    @server.run
  end

  def stop
    @server&.stop(true)
  end
end
