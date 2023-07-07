import axios from '@axios'

export default {
  namespaced: true,
  state: {},
  getters: {},
  mutations: {},
  actions: {
    fetchCareers(ctx, queryParams) {
      return new Promise((resolve, reject) => {
        axios
          .get('developer_careers', { params: queryParams })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    fetchCareer(ctx, { id }) {
      return new Promise((resolve, reject) => {
        axios
          .get(`developer_careers/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    addCareer(ctx, careerData) {
      return new Promise((resolve, reject) => {
        axios
          .post('developer_careers', { developer_career: careerData })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    updateCareer(ctx, [id, params = {}]) {
      return new Promise((resolve, reject) => {
        axios
          .put(`developer_careers/${id}`, { developer_career: params })
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    },
    deleteCareer(ctx, {id}) {
      return new Promise((resolve,reject) => {
        axios
          .delete(`developer_careers/${id}`)
          .then(response => resolve(response))
          .catch(error => reject(error))
      })
    }
  },
}
