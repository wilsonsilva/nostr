---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "Nostr"
  text: "Ruby"
  tagline: "The Nostr protocol implemented in a Ruby gem."
  actions:
    - theme: brand
      text: Getting Started
      link: /getting-started/overview
    - theme: alt
      text: View on Github
      link: https://github.com/wilsonsilva/nostr
    - theme: alt
      text: View on RubyDoc
      link: https://www.rubydoc.info/gems/nostr
    - theme: alt
      text: View on RubyGems
      link: https://rubygems.org/gems/nostr

features:
  - title: Asynchronous
    details: Non-blocking I/O for maximum performance.
    icon: ⚡
  - title: Lightweight
    details: Minimal runtime dependencies.
    icon: 🪶
  - title: Intuitive
    details: The API mirrors the Nostr protocol specification domain language.
    icon: 💡
  - title: Fully documented
    details: All code is documented from both the maintainer's as well as the consumer's perspective.
    icon: 📚
  - title: Fully tested
    details: All code is tested with 100% coverage.
    icon: 🧪
  - title: Fully typed
    details: All code is typed with <a href="https://rubygems.org/gems/rbs" target="_blank">RBS</a> with the help of <a href="https://rubygems.org/gems/typeprof" target="_blank">TypeProf</a>. Type correctness is enforced by <a href="https://rubygems.org/gems/steep" target="_blank">Steep</a>.
    icon: ✅
---
