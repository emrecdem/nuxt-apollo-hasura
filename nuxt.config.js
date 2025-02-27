import colors from 'vuetify/es5/util/colors'

// Check if we need to run Nuxt in development mode
const isDev = process.env.NODE_ENV !== 'production'

export default {
  publicRuntimeConfig: {
    xenonAPIKey: process.env.NUXT_XENON_API_KEY,
  },
  components: true,

  /*
   * Mode server side rendering
   */
  ssr: false,

  /*
   ** Headers of the page
   */
  head: {
    titleTemplate: '%s - ' + process.env.npm_package_name,
    title: process.env.npm_package_name || '',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      {
        hid: 'description',
        name: 'description',
        content: process.env.npm_package_description || '',
      },
    ],
    script: [
      {
        src: 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js',
      },
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
  },
  /*
   ** Customize the progress-bar color
   */
  loading: { color: '#3872FF' },
  /*
   ** Global CSS
   */
  css: [],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: [{ src: '~/plugins/vuex-persist', ssr: false }],

  /*
   ** Nuxt.js dev-modules
   */
  buildModules: [
    // Doc: https://github.com/nuxt-community/eslint-module
    '@nuxtjs/eslint-module',
    '@nuxtjs/vuetify',
  ],
  /*
   ** Nuxt.js modules
   */
  modules: ['@nuxtjs/pwa', '@nuxtjs/apollo', '@nuxtjs/axios', '@nuxtjs/proxy'],

  /**
   * Proxy
   */
  proxy: {
    '/graphql': {
      target: isDev ? 'http://localhost:8080/v1' : 'http://erd-hasura:8080/v1',
    },
    '/upload': {
      target: isDev ? 'http://localhost:7000' : 'http://erd-upload-server:7000',
    },
    '/jobs': {
      target: isDev ? 'http://localhost:9050' : 'http://erd-xenonflow:9050',
      onProxyReq(proxyReq) {
        proxyReq.setHeader('X-Forwarded-Host', 'localhost')
        proxyReq.setHeader('X-Forwarded-Server', 'localhost')
        proxyReq.setHeader('X-Forwarded-Proto', 'http')
        proxyReq.setHeader('X-Forwarded-Port', '3000')
        proxyReq.setHeader('X-Forwarded-Prefix', '')
      },
    },
    '/output': {
      target: isDev ? 'http://localhost:9050' : 'http://erd-xenonflow:9050',
      onProxyReq(proxyReq) {
        proxyReq.setHeader('X-Forwarded-Host', 'localhost')
        proxyReq.setHeader('X-Forwarded-Server', 'localhost')
        proxyReq.setHeader('X-Forwarded-Proto', 'http')
        proxyReq.setHeader('X-Forwarded-Port', '3000')
        proxyReq.setHeader('X-Forwarded-Prefix', '')
      },
    },
  },
  /**
   * Apollo
   */
  apollo: {
    // optional
    errorHandler: '~/plugins/apollo-error-handler.js',
    // required
    clientConfigs: {
      default: {
        httpEndpoint: '/graphql',
      },
    },
    defaultOptions: {
      $query: {
        loadingKey: 'loading',
        fetchPolicy: 'no-cache',
      },
    },
  },
  /*
   ** Vuetify module configuration
   ** https://github.com/nuxt-community/vuetify-module
   */
  vuetify: {
    customVariables: ['~/assets/variables.scss'],
    defaultAssets: {
      font: '', // <- Needed to dont' load Roboto font fro the cdn
    },
    treeShake: true,
    theme: {
      dark: false,
      themes: {
        light: {
          primary: colors.blue.lighten1,
        },
        dark: {
          primary: colors.green.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3,
        },
      },
    },
  },
  /*
   ** Build configuration
   */
  build: {
    hotMiddleware: {
      client: {
        overlay: false, // Disable Nuxt Black Screen ESLint
      },
    },
    /*
     ** You can extend webpack config here
     */
    extend(config, ctx) {},

    babel: {
      presets({ isServer }) {
        return [
          [
            require.resolve('@nuxt/babel-preset-app'),
            // require.resolve('@nuxt/babel-preset-app-edge'), // For nuxt-edge users
            {
              buildTarget: isServer ? 'server' : 'client',
              corejs: { version: 3 },
            },
          ],
        ]
      },
    },
  },

  pwa: {
    workbox: {
      // importScripts: ['/firebase-auth-sw.js'],
      // by default the workbox module will not install the service worker in dev environment to avoid conflicts with HMR
      // only set this true for testing and remember to always clear your browser cache in development
      // dev: process.env.NODE_ENV === 'development',
      debug: false,
    },
  },
}
