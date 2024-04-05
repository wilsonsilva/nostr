# Client

Clients establish a WebSocket connection to [relays](../relays/connecting-to-a-relay). Through this connection, clients
communicate and subscribe to a range of [Nostr events](../events) based on specified subscription filters. These filters
define the Nostr events a client wishes to receive updates about.

::: info
Clients do not need to sign up or create an account to use Nostr. Upon connecting to a relay, a client provides
its subscription filters. The relay then streams events that match these filters to the client for the duration of the
connection.
:::

## WebSocket events

Communication between clients and relays happen via WebSockets. The client will emit WebSocket events when the
connection is __opened__, __closed__, when a __message__ is received or when there's an __error__.

::: info
WebSocket events are not [Nostr events](https://nostr.com/the-protocol/events). They are events emitted by the
WebSocket connection. The WebSocket `:message` event, however, contains a Nostr event in its payload.
:::

### connect

The `:connect` event is fired when a connection with a WebSocket is opened. You must call `Nostr::Client#connect` first.

```ruby
client = Nostr::Client.new
relay = Nostr::Relay.new(url: 'wss://relay.damus.io', name: 'Damus')

client.on :connect do |relay|
  # When this block executes, you're connected to the relay
end

# Connect to a relay asynchronously
client.connect(relay)
```

Once the connection is open, you can send events to the relay, manage subscriptions, etc.

::: tip
Define the connection event handler before calling
[`Nostr::Client#connect`](https://www.rubydoc.info/gems/nostr/Nostr/Client#connect-instance_method). Otherwise,
you may miss the event.
:::

### error

The `:error` event is fired when a connection with a WebSocket has been closed because of an error.

```ruby
client.on :error do |error_message|
  puts error_message
end

# > Network error: wss://rsslay.fiatjaf.com: Unable to verify the
# server certificate for 'rsslay.fiatjaf.com'
```

### message

The `:message` event is fired when data is received through a WebSocket.

```ruby
client.on :message do |message|
  puts message
end
```

The message will be one of these 4 types, which must also be JSON arrays, according to the following patterns:
- `["EVENT", <subscription_id>, <event JSON>]`
- `["OK", <event_id>, <true|false>, <message>]`
- `["EOSE", <subscription_id>]`
- `["NOTICE", <message>]`

::: details Click me to see how a WebSocket message looks like
```ruby
[
  "EVENT",
  "d34107357089bfc9882146d3bfab0386",
  {
    "content": "",
    "created_at": 1676456512,
    "id": "18f63550da74454c5df7caa2a349edc5b2a6175ea4c5367fa4b4212781e5b310",
    "kind": 3,
    "pubkey": "117a121fa41dc2caa0b3d6c5b9f42f90d114f1301d39f9ee96b646ebfee75e36",
    "sig": "d171420bd62cf981e8f86f2dd8f8f86737ea2bbe2d98da88db092991d125535860d982139a3c4be39886188613a9912ef380be017686a0a8b74231dc6e0b03cb",
    "tags":[
      ["p", "1cc821cc2d47191b15fcfc0f73afed39a86ac6fb34fbfa7993ee3e0f0186ef7c"]
    ]
  }
]
```
:::

### close

The `:close` event is fired when a connection with a WebSocket is closed.

```ruby
client.on :close do |code, reason|
  puts "Error: #{code} - #{reason}"
end
```

::: tip
This handler is useful to attempt to reconnect to the relay.
:::
