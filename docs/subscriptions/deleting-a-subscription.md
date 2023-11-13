# Stop previous subscriptions

You can stop receiving messages from a subscription by calling
[`Nostr::Client#unsubscribe`](https://www.rubydoc.info/gems/nostr/Nostr/Client#unsubscribe-instance_method) with the
ID of the subscription you want to stop receiving messages from:

```ruby
client.unsubscribe('your-subscription-id')
client.unsubscribe(subscription.id)
```
