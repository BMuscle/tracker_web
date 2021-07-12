/* eslint @typescript-eslint/no-var-requires: 0 */
const path = require('path')

module.exports = {
  configureWebpack: {
    resolve: {
      alias: {
        config: path.resolve(`src/config/${process.env.NODE_ENV}.ts`)
      }
    }
  }
}
