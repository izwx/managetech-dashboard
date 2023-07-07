import appConfigStoreModule from '@core/@app-config/appConfigStoreModule'
import Vue from 'vue'
import Vuex from 'vuex'
import app from './app'
import sessionManager from "@/store/modules/session_manager";
import createPersistedState from 'vuex-persistedstate'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {},
  mutations: {},
  actions: {},
  plugins: [createPersistedState()],
  modules: {
    appConfig: appConfigStoreModule,
    app,
    sessionManager,
  },
})
