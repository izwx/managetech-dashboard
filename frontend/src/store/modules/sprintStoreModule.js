import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchSprints(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('sprints', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchSprint(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`sprints/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addSprint(ctx, sprintData) {
      return new Promise((resolve, reject) => {
        axios
          .post('sprints', { sprint: sprintData })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateSprint(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`sprints/${id}`, { sprint: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchSprintPhases(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('sprint_phases', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
  },
}
