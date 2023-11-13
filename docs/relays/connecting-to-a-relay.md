# Connecting to a Relay

You must connect your nostr [Client](../core/client) to a relay in order to send and receive [Events](../events).
Instantiate a [`Nostr::Client`](https://www.rubydoc.info/gems/nostr/Nostr/Client) and a
[`Nostr::Relay`](https://www.rubydoc.info/gems/nostr/Nostr/Relay) giving it the `url` of your relay. The `name`
attribute is just descriptive.
Calling [`Client#connect`](https://www.rubydoc.info/gems/nostr/Nostr/Client#connect-instance_method) attempts to
establish a WebSocket connection between the Client and the Relay.

```ruby
client = Nostr::Client.new
relay = Nostr::Relay.new(url: 'wss://relay.damus.io', name: 'Damus')

# Listen for the connect event
client.on :connect do
  # When this block executes, you're connected to the relay
end

# Connect to a relay asynchronously
client.connect(relay)
```
