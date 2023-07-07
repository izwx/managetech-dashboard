import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchProfile(ctx) {
      return new Promise((resolve, reject) => {
        axios
          .get(`profile`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateProfile(ctx, params) {
      return new Promise((resolve, reject) => {
        axios
        .put(`profile`, params)
        .then(response=> resolve(response))
        .catch(error => reject(error))
      })
    },
    updatePassword(ctx, params) {
      return new Promise((resolve, reject) => {
        axios
          .put(`passwords`, params)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
  },
}