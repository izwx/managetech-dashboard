import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchCompanies(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('companies', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchCompany(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`companies/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addCompany(ctx, companyData) {
      return new Promise((resolve, reject) => {
        axios
          .post('companies', { company: companyData })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateCompany(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`companies/${id}`, { company: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteCompany(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`companies/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
  },
}
