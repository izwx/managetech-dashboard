import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchTeams(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('teams', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchTeam(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`teams/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addTeam(ctx, teamData) {
      return new Promise((resolve, reject) => {
        axios
          .post('teams', { team: teamData })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateTeam(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`teams/${id}`, { team: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteTeam(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .delete(`teams/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
  },
}
