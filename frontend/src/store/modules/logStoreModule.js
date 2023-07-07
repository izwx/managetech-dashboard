import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchLogs(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('batch_logs', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchLog(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`batch_logs/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteLog(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`batch_logs/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
  },
}
