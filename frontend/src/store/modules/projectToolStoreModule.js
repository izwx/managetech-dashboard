import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchProjectTools(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('project_tool_infos', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchProjectTool(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`project_tool_infos/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addProjectTool(ctx, params) {
      return new Promise((resolve, reject) => {
        axios
          .post('project_tool_infos', { projectToolInfo: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateProjectTool(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`project_tool_infos/${id}`, { projectToolInfo: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteProjectTool(ctx, {id}) {
      return new Promise((resolve,reject) => {
        axios
          .delete(`project_tool_infos/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    }
  },
}
