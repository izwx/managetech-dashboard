<template>
  <!-- edit profile dialog -->
  <v-dialog v-model="isBioDialogOpen" max-width="650px" @click:outside="$emit('update:is-bio-dialog-open', false)">
    <v-card class="user-edit-info pa-sm-6 pa-3">
      <v-card-title class="justify-center text-h5">
        {{ $t('User Information') }}
      </v-card-title>

      <v-card-text class="mt-5">
        <v-list>
          <v-list-item dense class="px-0 mb-n2">
            <span class="font-weight-medium me-2">{{ $t('Name') }}:</span>
            <span class="text--secondary">{{ userDataLocal.name }}</span>
          </v-list-item>

          <v-list-item dense class="px-0 mb-n2">
            <span class="font-weight-medium text-no-wrap me-2">{{ $t('Email') }}:</span>
            <span class="text--secondary">{{ userDataLocal.email }}</span>
          </v-list-item>

          <v-list-item dense class="px-0 mb-n2">
            <span class="font-weight-medium me-2">{{ $t('Company Name') }}:</span>
            <span class="text--secondary" v-if="userDataLocal.company">{{ userDataLocal.company.companyName }}</span>
          </v-list-item>

          <v-list-item dense class="px-0 mb-n2">
            <span class="font-weight-medium me-2">{{ $t('Status') }}:</span>
            <span class="text--secondary">
              <v-chip
                small
                label
                :color="resolveUserStatusVariant(userDataLocal.status)"
                :class="`v-chip-light-bg ${resolveUserStatusVariant(
                  userDataLocal.status,
                )}--text font-weight-medium text-capitalize`"
              >
                {{ $t(`${userDataLocal.status}`) }}
              </v-chip>
            </span>
          </v-list-item>

          <v-list-item dense class="px-0 mb-n2">
            <span class="font-weight-medium me-2">{{ $t('Role') }}:</span>
            <span class="text--secondary text-capitalize">{{ $t(`${userDataLocal.role}`) }}</span>
          </v-list-item>

          <v-list-item dense class="px-0 mb-n2">
            <span class="font-weight-medium me-2">{{ $t('Register Date') }}:</span>
            <span class="text--secondary">{{ userDataLocal.registerDate }}</span>
          </v-list-item>
          <v-list-item dense class="px-0 mb-n2">
            <span class="font-weight-medium me-2">{{ $t('Last Login') }}:</span>
            <span class="text--secondary">{{ userDataLocal.lastSignInAt }}</span>
          </v-list-item>
        </v-list>
      </v-card-text>

      <v-card-actions class="justify-center pb-0">
        <v-btn color="primary" class="me-3" @click="onSubmit()"> OK </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { ref, watch } from '@vue/composition-api'
import store from '@/store'
import useUsersList from './useUsersList'

export default {
  props: {
    isBioDialogOpen: {
      type: Boolean,
      required: true,
    },
    userId: {
      type: Number,
      default: null,
    },
  },

  setup(props, { emit }) {
    const { resolveUserStatusVariant } = useUsersList()

    const userDataLocal = ref({})
    userDataLocal.value = JSON.parse(JSON.stringify({}))

    // on form submit
    const onSubmit = () => {
      emit('update:is-bio-dialog-open', false)
    }

    // fetch data
    const fetchUser = userId => {
      store
        .dispatch('app-user/fetchUser', userId)
        .then(response => {
          const { user } = response.data

          userDataLocal.value = user

          // remove loading state
          // loading.value = false
        })
        .catch(error => {
          console.log(error)
        })
    }

    watch(
      () => props.isBioDialogOpen,
      () => {
        if (props.isBioDialogOpen) {
          fetchUser({ id: props.userId })
        }
      },
    )

    return {
      resolveUserStatusVariant,

      userDataLocal,
      onSubmit,
      fetchUser,
    }
  },
}
</script>
