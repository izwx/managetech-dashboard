<template>
  <div class="auth-wrapper auth-v2">
    <div class="auth-inner">
      <!-- brand logo -->
      <router-link to="/" class="brand-logo d-flex align-center">
        <v-img :src="appLogo" max-height="30px" max-width="30px" alt="logo" contain class="me-3"></v-img>

        <h2 class="text--primary">
          {{ appName }}
        </h2>
      </router-link>
      <!--/ brand logo -->

      <v-row class="auth-row ma-0">
        <v-col lg="8" class="d-none d-lg-block position-relative overflow-hidden pa-0">
          <div class="auth-illustrator-wrapper">
            <!-- triangle bg -->
            <img
              height="362"
              class="auth-mask-bg"
              :src="require(`@/assets/images/misc/mask-v2-${$vuetify.theme.dark ? 'dark' : 'light'}.png`)"
            />

            <!-- tree -->
            <v-img height="226" width="300" class="auth-tree" src="@/assets/images/misc/tree-2.png"></v-img>

            <!-- 3d character -->
            <div class="d-flex align-center h-full pa-16 pe-0">
              <v-img
                contain
                max-width="100%"
                height="710"
                class="auth-3d-group"
                :src="
                  require(`@/assets/images/3d-characters/illustration-register-v2-${
                    $vuetify.theme.dark ? 'dark' : 'light'
                  }.png`)
                "
              ></v-img>
            </div>
          </div>
        </v-col>

        <v-col lg="4" class="d-flex align-center auth-bg pa-10 pb-0">
          <v-row>
            <v-col cols="12" sm="8" md="6" lg="12" class="mx-auto">
              <v-card flat>
                <v-card-text>
                  <p class="text-2xl font-weight-semibold text--primary my-2">Adventure starts here 🚀</p>
                  <p class="mb-2">Make your app management easy and fun!</p>
                </v-card-text>

                <v-card-text v-if="errorMessage">
                  <v-alert text type="error">
                    <small class="d-block mb-0">
                      {{ errorMessage }}
                    </small>
                  </v-alert>
                </v-card-text>

                <!-- login form -->
                <v-card-text>
                  <v-form ref="registerForm" @submit.prevent="handleFormSubmit">
                    <v-text-field
                      v-model="username"
                      outlined
                      label="Username"
                      :rules="[validators.required, validators.alphaValidator]"
                      placeholder="Username"
                      hide-details="auto"
                      class="mb-6"
                    ></v-text-field>

                    <v-text-field
                      v-model="email"
                      outlined
                      :rules="[validators.required, validators.emailValidator]"
                      label="Email"
                      placeholder="Email"
                      hide-details="auto"
                      class="mb-6"
                    ></v-text-field>

                    <v-text-field
                      v-model="password"
                      outlined
                      :type="isPasswordVisible ? 'text' : 'password'"
                      label="Password"
                      placeholder="Password"
                      :rules="[validators.required, validators.passwordValidator]"
                      :append-icon="isPasswordVisible ? icons.mdiEyeOffOutline : icons.mdiEyeOutline"
                      hide-details="auto"
                      class="mb-2"
                      @click:append="isPasswordVisible = !isPasswordVisible"
                    ></v-text-field>

                    <v-btn block color="primary" type="submit" class="mt-6"> Sign Up </v-btn>
                  </v-form>
                </v-card-text>

                <!-- create new account  -->
                <v-card-text class="d-flex align-center justify-center flex-wrap mt-2">
                  <p class="mb-0 me-2">Already have an account?</p>
                  <router-link :to="{ name: 'auth-login' }"> Sign in instead </router-link>
                </v-card-text>
              </v-card>
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </div>
  </div>
</template>

<script>
// eslint-disable-next-line object-curly-newline
import { mdiEyeOutline, mdiEyeOffOutline } from '@mdi/js'
// eslint-disable-next-line object-curly-newline
import { required, emailValidator, passwordValidator, alphaValidator } from '@core/utils/validation'
import { ref, getCurrentInstance } from '@vue/composition-api'
// import axios from '@axios'
import { useRouter } from '@core/utils'
import themeConfig from '@themeConfig'

import { useActions } from 'vuex-composition-helpers'

export default {
  setup() {
    // Template Refs
    const registerForm = ref(null)

    const vm = getCurrentInstance().proxy
    const { router } = useRouter()

    const isPasswordVisible = ref(false)
    const username = ref('johnDoe')
    const email = ref('john@managetech.io')
    const password = ref('test')
    const errorMessage = ref(null)

    const { registerUser } = useActions(['registerUser'])

    const handleFormSubmit = () => {
      const isFormValid = registerForm.value.validate()

      if (!isFormValid) return

      const data = {
        user: {
          username: username.value,
          email: email.value,
          password: password.value,
        },
      }

      registerUser(data)
        .then(() => {
          router.push('/')
        })
        .catch(error => {
          // TODO: Next Update - Show notification
          console.error('Oops, Unable to Register!')
          console.log('error :>> ', error.response)
          errorMessage.value = error.response.data.error
        })

      /*
        1. Make HTTP request to get accessToken (Register the user & login) (User will be added to the database and new generated access token will be sent for loggin in)
        2. Store received token in localStorage for future use
        3. Make another HTTP request for getting user information
        4. On successful response of user information redirect to home page

        ? We have use promise chaining to get user data from access token
        ? Promise Chaining: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises#chaining
      */

      // axios
      //   .post('/auth/register', { username: username.value, email: email.value, password: password.value })
      //   .then(response => {
      //     const { accessToken } = response.data

      //     // ? Set access token in localStorage so axios interceptor can use it
      //     // Axios Interceptors: https://github.com/axios/axios#interceptors
      //     localStorage.setItem('accessToken', accessToken)

      //     return response
      //   })
      //   .then(() => {
      //     axios.get('/auth/me').then(response => {
      //       const { user } = response.data
      //       const { ability: userAbility } = user

      //       // Set user ability
      //       // ? https://casl.js.org/v5/en/guide/intro#update-rules
      //       vm.$ability.update(userAbility)

      //       // ? Set user's ability in localStorage for Access Control
      //       localStorage.setItem('userAbility', JSON.stringify(userAbility))

      //       // ? We will store `userAbility` in localStorage separate from userData
      //       // ? Hence, we are just removing it from user object
      //       delete user.ability

      //       // ? Set user's data in localStorage for UI/Other purpose
      //       localStorage.setItem('userData', JSON.stringify(user))

      //       // ? On success redirect to home
      //       router.push('/')
      //     })
      //   })
      //   .catch(error => {
      //     // TODO: Next Update - Show notification
      //     console.error('Oops, Unable to Register!')
      //     console.log('error :>> ', error.response)
      //     errorMessages.value = error.response.data.error
      //   })
    }

    return {
      isPasswordVisible,
      username,
      email,
      password,
      errorMessage,
      handleFormSubmit,
      // socialLink,
      icons: {
        mdiEyeOutline,
        mdiEyeOffOutline,
      },
      validators: {
        required,
        emailValidator,
        passwordValidator,
        alphaValidator,
      },

      // themeConfig
      appName: themeConfig.app.name,
      appLogo: themeConfig.app.logo,

      // Template Refs
      registerForm,
    }
  },
}
</script>

<style lang="scss" scoped>
@import '@core/preset/preset/pages/auth.scss';
</style>
