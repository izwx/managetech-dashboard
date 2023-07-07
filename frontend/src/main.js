import '@/@fake-db/db'
import { i18n } from '@/plugins/i18n'
import '@/plugins/vue-composition-api'
import '@/styles/styles.scss'
import Vue from 'vue'
import App from './App.vue'
import './plugins/acl'
import vuetify from './plugins/vuetify'
import router from './router'
import store from './store'

/**
 * Load JWT from Local Storage on Refresh.
 */
let localAuthToken = localStorage.accessToken
let cookieExists = localAuthToken !== 'undefined' && localAuthToken !== null
if (cookieExists) {
  const accessToken = localStorage.getItem('accessToken')
  const authTokenExists = accessToken !== 'undefined' && accessToken !== null
  if (authTokenExists) {
    store.dispatch('loginUserWithToken', { accessToken })
  }
}

Vue.config.productionTip = false

new Vue({
  router,
  store,
  i18n,
  vuetify,
  render: h => h(App),
}).$mount('#app')
