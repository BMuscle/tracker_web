/* eslint-disable arrow-body-style */
// https://docs.cypress.io/guides/guides/plugins-guide.html

// if you need a custom webpack configuration you can uncomment the following import
// and then use the `file:preprocessor` event
// as explained in the cypress docs
// https://docs.cypress.io/api/plugins/preprocessors-api.html#Examples

// /* eslint-disable import/no-extraneous-dependencies, global-require */
// const webpack = require('@cypress/webpack-preprocessor')

/* eslint @typescript-eslint/no-var-requires: 0 */
const execSync = require('child_process').execSync
const clipboardy = require('clipboardy')

module.exports = (on, config) => {
  // on('file:preprocessor', webpack({
  //  webpackOptions: require('@vue/cli-service/webpack.config'),
  //  watchOptions: {}
  // }))
  on('task', {
    dbCreate (data) {
      const args = {
        method: 'create',
        data: data
      }
      const result = execSync(`cd ../ && bundle exec rails runner -e test ./scripts/e2e/factory.rb '${JSON.stringify(args)}'`)
      console.log('result=', result.toString())
      return null
    },
    dbUserCreate (data) {
      const args = {
        method: 'user_create',
        data: data
      }
      const result = execSync(`cd ../ && bundle exec rails runner -e test ./scripts/e2e/factory.rb '${JSON.stringify(args)}'`)
      console.log('result=', result.toString())
      return null
    },
    dbUserAssociationCreate (data) {
      const args = {
        method: 'user_association_create',
        data: data
      }
      const result = execSync(`cd ../ && bundle exec rails runner -e test ./scripts/e2e/factory.rb '${JSON.stringify(args)}'`)
      console.log('result=', result.toString())
      return null
    },
    dbAssociationCreate (data) {
      const args = {
        method: 'association_create',
        data: data
      }
      const result = execSync(`cd ../ && bundle exec rails runner -e test ./scripts/e2e/factory.rb '${JSON.stringify(args)}'`)
      console.log('result=', result.toString())
      return null
    },
    getClipboard () {
      return clipboardy.readSync()
    }
  })

  return Object.assign({}, config, {
    fixturesFolder: 'tests/e2e/fixtures',
    integrationFolder: 'tests/e2e/specs',
    screenshotsFolder: 'tests/e2e/screenshots',
    videosFolder: 'tests/e2e/videos',
    supportFile: 'tests/e2e/support/index.js'
  })
}
