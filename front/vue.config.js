module.exports = {
  devServer: {
    // Railsにアクセスするためのポートを指定する
    proxy: {
      '/api': {
        target: 'http://localhost:3000',
        pathRewrite: { '^/api/': '/' },
        logLevel: 'debug'
      }
    }
  }
}
