import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchSkills(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('skill_masters', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchAllSkills(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('all_skill_masters', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchSkill(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`skill_masters/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addSkill(ctx, skillData) {
      return new Promise((resolve, reject) => {
        axios
          .post('skill_masters', { skill_master: skillData })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateSkill(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`skill_masters/${id}`, { skill_master: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteSkill(ctx, {id}) {
      return new Promise((resolve,reject) => {
        axios
          .delete(`skill_masters/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    }
  },
}
