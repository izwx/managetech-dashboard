import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchDevelopers(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('developers', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchCurrentDevelopers(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('current_developers', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchDeveloper(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`developers/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addDeveloper(ctx, [developerData, companyId]) {
      return new Promise((resolve, reject) => {
        axios
          .post('developers', { developer: developerData, companyId: companyId })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateDeveloper(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`developers/${id}`, { developer: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteDeveloper(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`developers/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
  },
}
