# Contact List

## Creating/updating your contact list

Every new contact list that gets published overwrites the past ones, so it should contain all entries.

```ruby
# Creating a contact list event with 2 contacts
update_contacts_event = user.create_event(
  kind: Nostr::EventKind::CONTACT_LIST,
  tags: [
    [
      "p", # mandatory
      "32e1827635450ebb3c5a7d12c1f8e7b2b514439ac10a67eef3d9fd9c5c68e245", # public key of the user to add to the contacts
      "wss://alicerelay.com/", # can be an empty string or can be omitted
      "alice" # can be an empty string or can be omitted
    ],
    [
      "p", # mandatory
      "3efdaebb1d8923ebd99c9e7ace3b4194ab45512e2be79c1b7d68d9243e0d2681", # public key of the user to add to the contacts
      "wss://bobrelay.com/nostr", # can be an empty string or can be omitted
      "bob" # can be an empty string or can be omitted
    ],
  ],
)

# Send it to the Relay
client.publish(update_contacts_event)
```
