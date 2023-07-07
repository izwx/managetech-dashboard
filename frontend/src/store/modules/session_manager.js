import axios from 'axios'
import { getPermission } from '@/@core/utils/permissions'

const API_URL = `${process.env.VUE_APP_API_URL}/`

const state = {
  accessToken: null,
  user: {
    id: null,
    username: null,
    email: null,
    role: null,
    companyId: null,
  },
}
const getters = {
  getAuthToken(state) {
    return state.accessToken
  },
  getUserEmail(state) {
    return state.user?.email
  },
  getUserRole(state) {
    return state.user?.role
  },
  getUserID(state) {
    return state.user?.id
  },
  isLoggedIn(state) {
    const loggedOut = state.accessToken == null || state.accessToken === JSON.stringify(null)

    return !loggedOut
  },
}
const actions = {
  registerUser({ commit }, payload) {
    return new Promise((resolve, reject) => {
      axios
        .post(`${API_URL}users`, payload)
        .then(response => {
          commit('setUserInfo', response)
          resolve(response)
        })
        .catch(error => {
          reject(error)
        })
    })
  },
  loginUser({ commit }, payload) {
    return new Promise((resolve, reject) => {
      axios
        .post(`${API_URL}users/sign_in`, payload)
        .then(response => {
          commit('setUserInfo', response)
          resolve(response)
        })
        .catch(error => {
          reject(error)
        })
    })
  },
  logoutUser({ commit, state }) {
    const config = {
      headers: {
        Authorization: state.accessToken,
      },
    }
    return new Promise((resolve, reject) => {
      axios
        .delete(`${API_URL}users/sign_out`, config)
        .then(() => {
          resolve()
        })
        .catch(error => {
          reject(error)
        })
        .finally(() => {
          commit('resetUserInfo')
        })
    })
  },
  loginUserWithToken({ commit }, payload) {
    const config = {
      headers: {
        Authorization: payload.accessToken,
      },
    }
    new Promise((resolve, reject) => {
      axios
        .get(`${API_URL}member-data`, config)
        .then(response => {
          commit('setUserInfoFromToken', response)
          resolve(response)
        })
        .catch(error => {
          reject(error)
        })
    })
  },
}
const mutations = {
  UPDATE_USER_ROLE(state, value) {
    state.user.role = value
  },
  setUserInfo(state, data) {
    state.user = data.data.user
    state.accessToken = data.headers.authorization
    axios.defaults.headers.common.Authorization = data.headers.authorization

    const userRole = data.data.user ?  data.data.user.role : null

    const userAbility = getPermission(userRole)

    // Set user ability
    // ? https://casl.js.org/v5/en/guide/intro#update-rules
    this._vm.$ability.update(userAbility)

    // Set user's ability in localStorage for Access Control
    localStorage.setItem('userAbility', JSON.stringify(userAbility))

    // We will store `userAbility` in localStorage separate from userData
    // Hence, we are just removing it from user object
    delete data.data.user.ability

    // Set user's data in localStorage for UI/Other purpose
    localStorage.setItem('userData', JSON.stringify(data.data.user))
    
    localStorage.setItem('accessToken', data.headers.authorization)
  },
  setUserInfoFromToken(state, data) {

    if (data.data.user === null) {
      return this.commit("resetUserInfo", state)
    }
    state.user = data.data.user
    state.accessToken = localStorage.getItem('accessToken')

    const userRole = data.data.user ?  data.data.user.role : null

    const userAbility = getPermission(userRole)

    // Set user ability
    // ? https://casl.js.org/v5/en/guide/intro#update-rules
    this._vm.$ability.update(userAbility)

    // Set user's ability in localStorage for Access Control
    localStorage.setItem('userAbility', JSON.stringify(userAbility))

    // We will store `userAbility` in localStorage separate from userData
    // Hence, we are just removing it from user object
    delete data.data.user.ability

    // Set user's data in localStorage for UI/Other purpose
    localStorage.setItem('userData', JSON.stringify(data.data.user))
  },
  resetUserInfo(state) {
    state.user = {
      id: null,
      username: null,
      email: null,
    }
    state.accessToken = null
    localStorage.removeItem('accessToken')
    localStorage.removeItem('userData')
    localStorage.removeItem('userAbility')
    axios.defaults.headers.common.Authorization = null
  },
}
export default {
  state,
  getters,
  actions,
  mutations,
}
