import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchTools(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('tool_masters', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchTool(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`tool_masters/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addTool(ctx, toolData) {
      return new Promise((resolve, reject) => {
        axios
          .post('tool_masters', { tool_master: toolData })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateTool(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`tool_masters/${id}`, { tool_master: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteTool(ctx, {id}) {
      return new Promise((resolve,reject) => {
        axios
          .delete(`tool_masters/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    }
  },
}
