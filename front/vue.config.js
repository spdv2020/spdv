// vue.config.js
const path = require('path')

module.exports = {
  chainWebpack: config => {
    const types = ['vue-modules', 'vue', 'normal-modules', 'normal']
    types.forEach(type => addStyleResource(config.module.rule('scss').oneOf(type)))

    config
      .plugin('define')
      .tap(args => {
        const version = JSON.stringify(require('./package.json').version)
        args[0]['process.env']['VUE_APP_VERSION'] = version
        return args
      })
  },
}

function addStyleResource (rule) {
  rule.use('style-resource')
    .loader('style-resources-loader')
    .options({
      patterns: [
        path.resolve(__dirname, './src/styles/core/shared.scss'),
      ],
    })
}