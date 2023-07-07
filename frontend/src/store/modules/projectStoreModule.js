import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchProjects(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('projects', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchCurrentProjects(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('current_projects', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchProject(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`projects/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addProject(ctx, projectData) {
      return new Promise((resolve, reject) => {
        axios
          .post('projects', { project: projectData })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateProject(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`projects/${id}`, { project: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteProject(ctx, {id}) {
      return new Promise((resolve,reject) => {
        axios
          .delete(`projects/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchProjectPhases(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('project_phases', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchProjectStatuses(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('project_statuses', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
  },
}
