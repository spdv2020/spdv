import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

import { focus } from './directives'
import * as Maska from 'maska'

import './styles/core'

const app = createApp(App)
  .use(store)
  .use(router)

app.directive('focus', focus)
app.directive('maska', Maska.maska)

app.mount('#app')
