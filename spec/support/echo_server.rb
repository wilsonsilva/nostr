# frozen_string_literal: true

require 'puma'
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
    events = Puma::Events.new(StringIO.new, StringIO.new)
    binder = Puma::Binder.new(events)
    binder.parse(["tcp://0.0.0.0:#{port}"], self)
    @server = Puma::Server.new(self, events)
    @server.binder = binder
    @server.run
  end

  def stop
    case @server
    when Puma::Server then @server.stop(true)
    else @server.stop
    end
  end
end
