import { defineConfig } from 'vitepress'
import { withMermaid } from "vitepress-plugin-mermaid";

// https://vitepress.dev/reference/site-config
// https://www.npmjs.com/package/vitepress-plugin-mermaid
export default defineConfig(withMermaid({
  title: "Nostr",
  description: "Documentation of the Nostr Ruby gem",
  // https://vitepress.dev/reference/site-config#head
  head: [
    ['link', { rel: 'icon', href: '/favicon.ico' }]
  ],
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-last-updated
    lastUpdated: true,

    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Guide', link: '/getting-started/overview' }
    ],

    // https://vitepress.dev/reference/default-theme-search
    search: {
      provider: 'local'
    },

    // https://vitepress.dev/reference/default-theme-sidebar
    sidebar: [
      {
        text: 'Getting started',
        link: '/getting-started',
        collapsed: false,
        items: [
          { text: 'Overview', link: '/getting-started/overview' },
          { text: 'Installation', link: '/getting-started/installation' },
        ]
      },
      {
        text: 'Core',
        collapsed: false,
        items: [
          { text: 'Client', link: '/core/client' },
          { text: 'Keys', link: '/core/keys' },
          { text: 'User', link: '/core/user' },
        ]
      },
      {
        text: 'Relays',
        items: [
          { text: 'Connecting to a relay', link: '/relays/connecting-to-a-relay' },
          { text: 'Publishing events', link: '/relays/publishing-events' },
          { text: 'Receiving events', link: '/relays/receiving-events' },
        ]
      },
      {
        text: 'Subscriptions',
        collapsed: false,
        items: [
          { text: 'Creating a subscription', link: '/subscriptions/creating-a-subscription' },
          { text: 'Filtering subscription events', link: '/subscriptions/filtering-subscription-events' },
          { text: 'Updating a subscription', link: '/subscriptions/updating-a-subscription' },
          { text: 'Deleting a subscription', link: '/subscriptions/deleting-a-subscription' },
        ]
      },
      {
        text: 'Events',
        link: '/events',
        collapsed: false,
        items: [
          { text: 'Set Metadata', link: '/events/set-metadata' },
          { text: 'Text Note', link: '/events/text-note' },
          { text: 'Recommend Server', link: '/events/recommend-server' },
          { text: 'Contact List', link: '/events/contact-list' },
          { text: 'Encrypted Direct Message', link: '/events/encrypted-direct-message' },
        ]
      },
      {
        text: 'Implemented NIPs',
        link: '/implemented-nips',
      },
    ],

    // https://vitepress.dev/reference/default-theme-config#sociallinks
    socialLinks: [
      { icon: 'github', link: 'https://github.com/wilsonsilva/nostr' }
    ],

    // https://vitepress.dev/reference/default-theme-edit-link
    editLink: {
      pattern: 'https://github.com/wilsonsilva/nostr/edit/main/docs/:path',
      text: 'Edit this page on GitHub'
    },

    // https://vitepress.dev/reference/default-theme-footer
    footer: {
      message: 'Released under the <a href="https://github.com/wilsonsilva/nostr/blob/main/LICENSE.txt">MIT License</a>.',
      copyright: 'Copyright © 2023-present <a href="https://github.com/wilsonsilva">Wilson Silva</a>'
    }
  },

  // https://vitepress.dev/reference/site-config#ignoredeadlinks
  ignoreDeadLinks: [
    /^https?:\/\/localhost/
  ],
}))
