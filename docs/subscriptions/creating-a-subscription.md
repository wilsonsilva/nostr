# Creating a subscription

A client can request events and subscribe to new updates __after__ it has established a connection with the Relay.

You may use a [`Nostr::Filter`](https://www.rubydoc.info/gems/nostr/Nostr/Filter) instance with as many attributes as
you wish:

```ruby
client.on :connect do
  filter = Nostr::Filter.new(
    ids: ['8535d5e2d7b9dc07567f676fbe70428133c9884857e1915f5b1cc6514c2fdff8'],
    authors: ['ae00f88a885ce76afad5cbb2459ef0dcf0df0907adc6e4dac16e1bfbd7074577'],
    kinds: [Nostr::EventKind::TEXT_NOTE],
    e: ["f111593a72cc52a7f0978de5ecf29b4653d0cf539f1fa50d2168fc1dc8280e52"],
    p: ["f1f9b0996d4ff1bf75e79e4cc8577c89eb633e68415c7faf74cf17a07bf80bd8"],
    since: 1230981305,
    until: 1292190341,
    limit: 420,
  )

  subscription = client.subscribe(subscription_id: 'an-id', filter: filter)
end
```

With just a few:

```ruby
client.on :connect do
  filter = Nostr::Filter.new(kinds: [Nostr::EventKind::TEXT_NOTE])
  subscription = client.subscribe(subscription_id: 'an-id', filter: filter)
end
```

Or omit the filter:

```ruby
client.on :connect do
  subscription = client.subscribe(subscription_id: 'an-id')
end
```

Or even omit the subscription id:

```ruby
client.on :connect do
  subscription = client.subscribe(filter: filter)
  subscription.id # => "13736f08dee8d7b697222ba605c6fab2" (randomly generated)
end
```
