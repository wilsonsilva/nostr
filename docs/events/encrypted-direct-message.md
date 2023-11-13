# Encrypted Direct Message

## Sending an encrypted direct message

```ruby
sender_private_key = '3185a47e3802f956ca5a2b4ea606c1d51c7610f239617e8f0f218d55bdf2b757'

encrypted_direct_message = Nostr::Events::EncryptedDirectMessage.new(
   sender_private_key: sender_private_key,
   recipient_public_key: '6c31422248998e300a1a457167565da7d15d0da96651296ee2791c29c11b6aa0',
   plain_text: 'Your feedback is appreciated, now pay $8',
   previous_direct_message: 'ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460' # optional
)

encrypted_direct_message.sign(sender_private_key)

# #<Nostr::Events::EncryptedDirectMessage:0x0000000104c9fa68
# @content="mjIFNo1sSP3KROE6QqhWnPSGAZRCuK7Np9X+88HSVSwwtFyiZ35msmEVoFgRpKx4?iv=YckChfS2oWCGpMt1uQ4GbQ==",
#   @created_at=1676456512,
#   @id="daac98826d5eb29f7c013b6160986c4baf4fe6d4b995df67c1b480fab1839a9b",
#   @kind=4,
#   @pubkey="8a9d69c56e3c691bec8f9565e4dcbe38ae1d88fffeec3ce66b9f47558a3aa8ca",
#   @sig="028bb5f5bab0396e2065000c84a4bcce99e68b1a79bb1b91a84311546f49c5b67570b48d4a328a1827e7a8419d74451347d4f55011a196e71edab31aa3d6bdac",
#   @tags=[["p", "6c31422248998e300a1a457167565da7d15d0da96651296ee2791c29c11b6aa0"], ["e", "ccf9fdf3e1466d7c20969c71ec98defcf5f54aee088513e1b73ccb7bd770d460"]]>

# Send it to the Relay
client.publish(encrypted_direct_message)
```
