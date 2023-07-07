// axios
import axios from 'axios'
import Vue from 'vue'
import { decamelizeKeys, camelizeKeys } from '@core/utils'
import store from '@/store'

const axiosIns = axios.create({
  // You can add your headers here
  // ================================
  baseURL: `${process.env.VUE_APP_API_URL}/api/v1/`,
  // timeout: 1000,
  // headers: {'X-Custom-Header': 'foobar'}
})

// Axios middleware to convert all api responses to camelCase
axiosIns.interceptors.response.use(
  response => {
    if (response.data && response.headers['content-type'].includes('application/json')) {
      response.data = camelizeKeys(response.data)
    }
    return response
  },
  err => {
    const originalConfig = err.config

    if (originalConfig.url !== '/auth/signin' && err.response) {
      // Access Token was expired
      if (err.response.status === 401 && !originalConfig._retry) {
        originalConfig._retry = true

        try {
          // Redirect to login page
          store.commit('resetUserInfo')
          window.location.href = '/login'
        } catch (_error) {
          return Promise.reject(_error)
        }
      }
    }
    // Do something with response error
    return Promise.reject(err)
  },
)

// Axios middleware to convert all api requests to snake_case
axiosIns.interceptors.request.use(
  config => {
    // Do something before request is sent
    const newConfig = { ...config }

    const accessToken = localStorage.getItem('accessToken')

    // eslint-disable-next-line no-param-reassign
    if (accessToken) newConfig.headers.Authorization = `${accessToken}`

    if (newConfig.headers['Content-Type'] === 'multipart/form-data') return newConfig
    if (config.params) {
      newConfig.params = decamelizeKeys(config.params)
    }
    if (config.data) {
      newConfig.data = decamelizeKeys(config.data)
    }

    return newConfig
  },
  error => Promise.reject(error),
)

Vue.prototype.$http = axiosIns

export default axiosIns
