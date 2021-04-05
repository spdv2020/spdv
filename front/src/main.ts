import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

import { focus } from './directives'
import * as Maska from 'maska'

import './styles/core'

import { setLocale } from 'yup'

declare global {
  interface Window {
    onScan: any;
  }
}

setLocale({
  mixed: {
    required: 'Campo obrigatório'
  },
  string: {
    email: 'Informe um email válido',
    // eslint-disable-next-line no-template-curly-in-string
    min: 'O campo deve ter no minímo ${min} caracteres',
    // eslint-disable-next-line no-template-curly-in-string
    max: 'O campo deve ter no máximo ${max} caracteres'
  }
})

const app = createApp(App)
  .use(store)
  .use(router)

app.directive('focus', focus)
app.directive('maska', Maska.maska)

app.mount('#app')
