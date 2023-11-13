# Recommend Server

The `Recommend Server` event, has a set of tags with the following structure `['e', <event-id>, <relay-url>, <marker>]`

Where:

- `<event-id>` is the id of the event being referenced.
- `<relay-url>` is the URL of a recommended relay associated with the reference. Clients SHOULD add a valid `<relay-URL>`
field, but may instead leave it as `''`.
- `<marker>` is optional and if present is one of `'reply'`, `'root'`, or `'mention'`.
Those marked with `'reply'` denote the id of the reply event being responded to. Those marked with `'root'` denote the
root id of the reply thread being responded to. For top level replies (those replying directly to the root event),
only the `'root'` marker should be used. Those marked with `'mention'` denote a quoted or reposted event id.

A direct reply to the root of a thread should have a single marked `'e'` tag of type `'root'`.

## Recommending a server

```ruby
recommend_server_event = user.create_event(
  kind: Nostr::EventKind::RECOMMEND_SERVER,
  tags: [
    [
      'e',
      '461544014d87c9eaf3e76e021240007dff2c7afb356319f99c741b45749bf82f',
      'wss://relay.damus.io'
    ],
  ]
)

client.publish(recommend_server_event)
```
