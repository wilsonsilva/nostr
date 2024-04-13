# 3. Logger Types

Date: 2024-04-01

## Status

Accepted

## Context

In developing the `Nostr::Client` logging mechanism, I identified a need to cater to multiple development environments
and developer preferences. The consideration was whether to implement a singular logger type or to introduce
multiple, specialized loggers. The alternatives were:

- A single `ClientLogger` providing a one-size-fits-all solution.
- Multiple logger types:
  - `Nostr::Client::Logger`: The base class for logging, providing core functionalities.
  - `Nostr::Client::ColorLogger`: An extension of the base logger, introducing color-coded outputs for enhanced readability in environments that support ANSI colors.
  - `Nostr::Client::PlainLogger`: A variation that produces logs without color coding, suitable for environments lacking color support or for users preferring plain text.

## Decision

I decided to implement the latter option: three specific kinds of loggers (`Nostr::Client::Logger`,
`Nostr::Client::ColorLogger`, and `Nostr::Client::PlainLogger`). This approach is intended to offer flexibility and
cater to the varied preferences and requirements of our users, recognizing the diverse environments in which our
library might be used.

## Consequences

- `Developer Choice`: Developers gain the ability to select the one that best matches their needs and environmental constraints, thereby enhancing the library's usability.
- `Code Complexity`: While introducing multiple logger types increases the library's code complexity, this is offset by the significant gain in flexibility and user satisfaction.
- `Broad Compatibility`: This decision ensures that the logging mechanism is adaptable to a wide range of operational environments, enhancing the library's overall robustness and accessibility.
