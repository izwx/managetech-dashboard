import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchProjectTeams(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('project_team_maps', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchProjectTeam(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`project_team_maps/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addProjectTeam(ctx, params) {
      return new Promise((resolve, reject) => {
        axios
          .post('project_team_maps', { projectTeamMap: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateProjectTeam(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`project_team_maps/${id}`, { projectTeamMap: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteProjectTeam(ctx, {id}) {
      return new Promise((resolve,reject) => {
        axios
          .delete(`project_team_maps/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    }
  },
}