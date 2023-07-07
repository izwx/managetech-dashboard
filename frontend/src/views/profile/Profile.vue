<template>
  <div>
    <v-row>
      <v-col cols="12" md="5" lg="4">
        <user-bio-panel
          :user-data="profileData"
          @avatar-upload="updatePofileImage"
          @avatar-delete="deletePofileImage"
        ></user-bio-panel>
      </v-col>
      <v-col cols="12" md="7" lg="8">
        <v-card class="mb-5" v-if="$can('all', 'profile_setting')">
          <v-card-title>
            {{ $t('Edit Profile') }}
          </v-card-title>

          <v-card-text v-if="profileErrorMessage">
            <v-alert text type="error">
              <small class="d-block mb-0">
                {{ profileErrorMessage }}
              </small>
            </v-alert>
          </v-card-text>

          <v-card-text v-if="successMessage">
            <v-alert text type="success">
              <small class="d-block mb-0">
                {{ successMessage }}
              </small>
            </v-alert>
          </v-card-text>

          <v-card-text>
            <v-form ref="form" v-model="profileValid" @submit.prevent="submitProfile">
              <v-text-field
                v-model="newProfileData.name"
                :label="$t('Name')"
                :placeholder="$t('Name')"
                type="text"
                outlined
                dense
                :rules="[validators.required]"
              ></v-text-field>
              <v-text-field
                v-model="newProfileData.email"
                :label="$t('Email')"
                :placeholder="$t('Email')"
                type="email"
                outlined
                dense
                :rules="[validators.required, validators.emailValidator]"
              ></v-text-field>

              <v-btn color="primary" type="submit">
                {{ $t('Update') }}
              </v-btn>

              <v-btn type="reset" outlined class="mx-2">
                {{ $t('Reset') }}
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>

        <v-card>
          <v-card-title>
            {{ $t('Change Password') }}
          </v-card-title>

          <v-card-text v-if="pwErrorMessage">
            <v-alert text type="error">
              <small class="d-block mb-0">
                {{ pwErrorMessage }}
              </small>
            </v-alert>
          </v-card-text>

          <v-card-text>
            <v-form ref="pwform" v-model="pwValid" @submit.prevent="submitPassword">
              <v-text-field
                v-model="newPasswordData.currentPassword"
                :label="$t('Current Password')"
                :placeholder="$t('Current Password')"
                outlined
                dense
                type="password"
                :rules="[validators.required]"
              ></v-text-field>

              <v-text-field
                v-model="newPasswordData.password"
                :label="$t('Password')"
                :placeholder="$t('Password')"
                outlined
                dense
                type="password"
                :rules="[validators.required, validators.passwordValidator]"
              ></v-text-field>

              <v-text-field
                v-model="newPasswordData.confirmPassword"
                :label="$t('Confirm Password')"
                :placeholder="$t('Confirm Password')"
                outlined
                dense
                type="password"
                :rules="[
                  validators.required,
                  validators.confirmedValidator(newPasswordData.confirmPassword, newPasswordData.password),
                ]"
              ></v-text-field>

              <v-btn color="primary" type="submit">
                {{ $t('Update') }}
              </v-btn>

              <v-btn type="reset" outlined class="mx-2" @click.prevent="pwFormReset">
                {{ $t('Reset') }}
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
// eslint-disable-next-line object-curly-newline
import store from '@/store'
import axios from '@axios'
import { required, emailValidator, passwordValidator, confirmedValidator } from '@core/utils/validation'
import { ref, onUnmounted, watch } from '@vue/composition-api'
import profileStoreModule from '@/store/modules/profileStoreModule'
import UserBioPanel from './UserBioPanel.vue'
import useProfile from './useProfile'

export default {
  components: {
    UserBioPanel,
  },
  setup() {
    const PROFILE_STORE_MODULE_NAME = 'app-profile'
    //Register module
    if (!store.hasModule(PROFILE_STORE_MODULE_NAME)) store.registerModule(PROFILE_STORE_MODULE_NAME, profileStoreModule)
    //Unregister on leave
    onUnmounted(() => {
      if (store.hasModule(PROFILE_STORE_MODULE_NAME)) store.unregisterModule(PROFILE_STORE_MODULE_NAME)
    })

    const { profileData, fetchProfile } = useProfile()

    fetchProfile()

    const form = ref(null)
    const profileValid = ref(false)
    const successMessage = ref(null)
    const profileErrorMessage = ref(null)
    const pwform = ref(null)
    const pwValid = ref(false)
    const pwErrorMessage = ref(null)

    /**Profile Data handle */
    const blankProfileData = {
      email: '',
      name: '',
    }
    const newProfileData = ref(JSON.parse(JSON.stringify(blankProfileData)))

    watch(profileData, (currentVal, oldVal) => {
      newProfileData.value = JSON.parse(JSON.stringify(currentVal))
    })
    const validate = () => {
      form.value.validate()
    }

    const submitProfile = () => {
      if (profileValid.value) {
        // Submit profile data
        store
          .dispatch('app-profile/updateProfile', newProfileData.value)
          .then(response => {
            store.commit('setUserInfoFromToken', response)
            successMessage.value = "アップデートに成功しました"
            setTimeout(() => {
              successMessage.value = null
            }, 3000);
          })
          .catch(error => {
            const { errors } = error.response.data
            profileErrorMessage.value = errors[0]
          })
      } else {
        validate()
      }
    }

    /**Password Data handle */
    const blankPasswordData = {
      currentPassword: '',
      password: '',
      confirmPassword: '',
    }
    const newPasswordData = ref(JSON.parse(JSON.stringify(blankPasswordData)))
    const pwvalidate = () => {
      pwform.value.validate()
    }
    const pwFormReset = () => {
      pwform.value.reset()
    }
    const submitPassword = () => {
      if (pwValid.value) {
        // submit password
        store
          .dispatch('app-profile/updatePassword', newPasswordData.value)
          .then(res => {
            pwErrorMessage.value = null
            newPasswordData.value = JSON.parse(JSON.stringify(blankPasswordData))
            pwFormReset()
          })
          .catch(error => {
            const { errors } = error.response.data
            pwErrorMessage.value = errors[0]
          })
      } else {
        pwvalidate()
      }
    }

    const updatePofileImage = file => {
      const formData = new FormData()
      formData.append('file', file)
      axios
        .post(
          'profile/update_avatar',
          formData,
          {
            headers: {
              'Content-Type': 'multipart/form-data',
            },
            withCredentials: false,
          },
          { decamelizeRequest: false },
        )
        .then(result => {
          fetchProfile()
        })
        .catch(error => {
          console.error(error)
        })
    }

    const deletePofileImage = () => {
      const formData = new FormData()
      if (profileData.value && profileData.value.avatarUrl) {
        formData.append('url', profileData.value.avatarUrl)
        axios
          .post(
            'profile/delete_avatar',
            formData,
            {
              headers: {
                'Content-Type': 'multipart/form-data',
              },
              withCredentials: false,
            },
            { decamelizeRequest: false },
          )
          .then(result => {
            fetchProfile()
          })
          .catch(error => {
            console.error(error)
          })
      }
      return
    }

    return {
      profileData,

      form,
      profileValid,
      successMessage,
      profileErrorMessage,
      newProfileData,
      submitProfile,
      updatePofileImage,
      deletePofileImage,

      pwform,
      pwValid,
      pwErrorMessage,
      newPasswordData,
      pwFormReset,
      submitPassword,

      // validation rules
      validators: {
        required,
        emailValidator,
        passwordValidator,
        confirmedValidator,
      },
    }
  },
}
</script>
