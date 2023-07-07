import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchDeveloperTeams(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('developer_team_maps', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchDeveloperTeam(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`developer_team_maps/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addDeveloperTeam(ctx, params) {
      return new Promise((resolve, reject) => {
        axios
          .post('developer_team_maps', { developerTeamMap: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateDeveloperTeam(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`developer_team_maps/${id}`, { developerTeamMap: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteDeveloperTeam(ctx, {id}) {
      return new Promise((resolve,reject) => {
        axios
          .delete(`developer_team_maps/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    }
  },
}