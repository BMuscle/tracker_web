module.exports = {
  transpileDependencies: [
    'vuetify'
  ],
  publicPath: '/tracker',
  pluginOptions: {
    i18n: {
      locale: 'ja',
      fallbackLocale: 'ja',
      localeDir: 'locales',
      enableInSFC: true
    }
  }
}
