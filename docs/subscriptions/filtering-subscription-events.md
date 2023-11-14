# Filtering events

## Filtering by id

You can filter events by their ids:

```ruby
filter = Nostr::Filter.new(
  ids: [
    # matches events with these exact IDs
    '8535d5e2d7b9dc07567f676fbe70428133c9884857e1915f5b1cc6514c2fdff8',
    '461544014d87c9eaf3e76e021240007dff2c7afb356319f99c741b45749bf82f',
  ]
)
subscription = client.subscribe(filter: filter)
```

## Filtering by author

You can filter events by their author's pubkey:

```ruby
filter = Nostr::Filter.new(
  authors: [
    # matches events whose (authors) pubkey match these exact IDs
    'b698043170d580f8ae5bad4ac80b1fdb508e957f0bbffe97f2a8915fa8b34070',
    '51f853ff4894b062950e46ebed8c1c7015160f8173994414a96dd286f65f0f49',
  ]
)
subscription = client.subscribe(filter: filter)
```

## Filtering by kind

You can filter events by their kind:

```ruby
filter = Nostr::Filter.new(
  kinds: [
    # matches events whose kind is TEXT_NOTE
    Nostr::EventKind::TEXT_NOTE,
    # and matches events whose kind is CONTACT_LIST
    Nostr::EventKind::CONTACT_LIST,
  ]
)
subscription = client.subscribe(filter: filter)
```

## Filtering by referenced event

You can filter events by the events they reference (in their `e` tag):

```ruby
filter = Nostr::Filter.new(
  e: [
    # matches events that reference other events whose ids match these exact IDs
    'f111593a72cc52a7f0978de5ecf29b4653d0cf539f1fa50d2168fc1dc8280e52',
    'f1f9b0996d4ff1bf75e79e4cc8577c89eb633e68415c7faf74cf17a07bf80bd8',
  ]
)
subscription = client.subscribe(filter: filter)
```

## Filtering by referenced pubkey

You can filter events by the pubkeys they reference (in their `p` tag):

```ruby
filter = Nostr::Filter.new(
  p: [
    # matches events that reference other pubkeys that match these exact IDs
    'b698043170d580f8ae5bad4ac80b1fdb508e957f0bbffe97f2a8915fa8b34070',
    '51f853ff4894b062950e46ebed8c1c7015160f8173994414a96dd286f65f0f49',
  ]
)
subscription = client.subscribe(filter: filter)
```

## Filtering by timestamp

You can filter events by their timestamp:

```ruby
filter = Nostr::Filter.new(
  since: 1230981305, # matches events that are newer than this timestamp
  until: 1292190341, # matches events that are older than this timestamp
)
subscription = client.subscribe(filter: filter)
```

## Limiting the number of events

You can limit the number of events received:

```ruby
filter = Nostr::Filter.new(
  limit: 420, # matches at most 420 events
)
subscription = client.subscribe(filter: filter)
```

## Combining filters

You can combine filters. For example, to match `5` text note events that are newer than `1230981305` from the author
`ae00f88a885ce76afad5cbb2459ef0dcf0df0907adc6e4dac16e1bfbd7074577`:

```ruby
filter = Nostr::Filter.new(
  authors: ['ae00f88a885ce76afad5cbb2459ef0dcf0df0907adc6e4dac16e1bfbd7074577'],
  kinds: [Nostr::EventKind::TEXT_NOTE],
  since: 1230981305,
  limit: 5,
)
subscription = client.subscribe(filter: filter)
```
