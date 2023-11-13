# Nostr Docs

VitePress-powered documentation for the Nostr Ruby gem.

## Live Demo

https://nostr-ruby.com/

## Development

### Requirements

- [Bun](https://bun.sh/)

### Installation

```shell
bun install
```

### Tasks

The `docs:dev` script will start a local dev server with instant hot updates. Run it with the following command:

```shell
bun run docs:dev
```

Run this command to build the docs:

```shell
bun run docs:build
```

Once built, preview it locally by running:

```shell
bun run docs:preview
```

The preview command will boot up a local static web server that will serve the output directory .`vitepress/dist` at
http://localhost:4173. You can use this to make sure everything looks good before pushing to production.


