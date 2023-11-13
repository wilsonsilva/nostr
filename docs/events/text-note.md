# Text Note

In the `Text Note` event, the `content` is set to the plaintext content of a note (anything the user wants to say).
Content that must be parsed, such as Markdown and HTML, should not be used.

## Sending a text note event

```ruby
text_note_event = user.create_event(
  kind: Nostr::EventKind::TEXT_NOTE,
  content: 'Your feedback is appreciated, now pay $8'
)

client.publish(text_note_event)
```
