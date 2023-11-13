# Set Metadata

In the `Metadata` event, the `content` is set to a stringified JSON object
`{name: <username>, about: <string>, picture: <url, string>}` describing the [user](../core/user) who created the event. A relay may
delete older events once it gets a new one for the same pubkey.

## Setting the user's metadata

```ruby
metadata_event = user.create_event(
  kind: Nostr::EventKind::SET_METADATA,
  content: {
    name: 'Wilson Silva',
    about: 'Used to make hydrochloric acid bombs in high school.',
    picture: 'https://thispersondoesnotexist.com/'
  }
)

client.publish(metadata_event)
```
