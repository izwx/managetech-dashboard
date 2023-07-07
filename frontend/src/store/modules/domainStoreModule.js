import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchDomains(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('domain_masters', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchAllDomains(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('all_domain_masters', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchDomain(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`domain_masters/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addDomain(ctx, domainData) {
      return new Promise((resolve, reject) => {
        axios
          .post('domain_masters', { domain_master: domainData })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateDomain(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`domain_masters/${id}`, { domain_master: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteDomain(ctx, {id}) {
      return new Promise((resolve,reject) => {
        axios
          .delete(`domain_masters/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    }
  },
}
