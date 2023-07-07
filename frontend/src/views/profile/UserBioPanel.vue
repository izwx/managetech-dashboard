<template>
  <v-row class="user-bio-panel">
    <!-- user profile -->
    <v-col cols="12">
      <v-card class="pt-10">
        <v-card-title class="justify-center flex-column">
          <v-avatar
            :color="userData.avatarUrl ? '' : 'primary'"
            :class="userData.avatarUrl ? '' : 'v-avatar-light-bg primary--text'"
            size="120"
            rounded
            class="mb-4"
          >
            <v-img v-if="userData.avatarUrl" :src="userData.avatarUrl"></v-img>
            <span v-else class="font-weight-semibold text-5xl">{{ avatarText(userData.email) }}</span>
          </v-avatar>
          <input type="file" ref="uploader" @change="onFileChanged" hidden>

          <span class="mb-2">{{ userData.email }}</span>

          <v-chip
            label
            small
            :color="resolveUserRoleVariant(userData.role)"
            :class="`v-chip-light-bg text-sm font-weight-semibold ${resolveUserRoleVariant(
              userData.role,
            )}--text text-capitalize`"
          >
            {{ $t(`${userData.role}`) }}
          </v-chip>
        </v-card-title>

        <v-card-text>
          <div class="d-flex justify-space-between">
            <h2 class="text-xl font-weight-semibold mb-2">{{$t('Details')}}</h2>
            <div>
              <v-btn x-small color="primary" class="mr-1" @click="handleFileImport" >{{$t('Edit photo')}}</v-btn>
              <v-btn x-small color="primary" @click="handleFileDelete">{{$t('Delete photo')}}</v-btn>
            </div>
          </div>

          <v-divider></v-divider>

          <v-list>
            <v-list-item dense class="px-0 mb-n2">
              <span class="font-weight-medium text-no-wrap me-2">{{$t('Email')}}:</span>
              <span class="text--secondary">{{ userData.email }}</span>
            </v-list-item>
            <v-list-item dense class="px-0 mb-n2">
              <span class="font-weight-medium me-2">{{$t('Status')}}:</span>
              <span class="text--secondary">
                <v-chip
                  small
                  label
                  :color="resolveUserStatusVariant(userData.status)"
                  :class="`v-chip-light-bg ${resolveUserStatusVariant(
                    userData.status,
                  )}--text font-weight-medium text-capitalize`"
                >
                  {{ $t(`${userData.status}`) }}
                </v-chip>
              </span>
            </v-list-item>
            <v-list-item dense class="px-0 mb-n2">
              <span class="font-weight-medium me-2">{{$t('Company')}}:</span>
              <span class="text--secondary" v-if="userData.company">{{ userData.company.companyName }}</span>
            </v-list-item>
            <v-list-item dense class="px-0 mb-n2">
              <span class="font-weight-medium me-2">{{$t('Role')}}:</span>
              <span class="text--secondary text-capitalize">{{ $t(`${userData.role}`) }}</span>
            </v-list-item>
            <v-list-item dense class="px-0 mb-n2">
              <span class="font-weight-medium me-2">{{ $t('Register Date') }}:</span>
              <span class="text--secondary">{{ userData.registerDate }}</span>
            </v-list-item>
            <v-list-item dense class="px-0 mb-n2">
              <span class="font-weight-medium me-2">{{ $t('Last Login') }}:</span>
              <span class="text--secondary">{{ userData.lastSignInAt }}</span>
            </v-list-item>
          </v-list>
        </v-card-text>

      </v-card>

    </v-col>
  </v-row>
</template>

<script>
import { avatarText } from '@core/utils/filter'
import { ref } from '@vue/composition-api'

export default {
  props: {
    userData: {
      type: Object,
      required: true,
    },
  },
  setup(props, context) {
    const resolveUserStatusVariant = status => {
      if (status === 'pending') return 'warning'
      if (status === 'active') return 'success'
      if (status === 'inactive') return 'secondary'

      return 'primary'
    }

    const resolveUserRoleVariant = role => {
      if (role === 'developer') return 'primary'
      if (role === 'client') return 'warning'
      if (role === 'projectManager') return 'success'
      if (role === 'manager') return 'info'
      if (role === 'superAdmin') return 'error'

      return 'primary'
    }

    const uploader = ref(null)

    const handleFileImport = () => {
      uploader.value.click()
    }

    const handleFileDelete = () => {
      context.emit("avatar-delete")
    }

    const onFileChanged = (event) => {
      if (!event.target.files || event.target.files.length === 0) {
        return
      }
      const file = event.target.files[0]
      context.emit("avatar-upload", file)
    }

    return {
      handleFileImport,
      handleFileDelete,
      onFileChanged,
      uploader,
      resolveUserStatusVariant,
      resolveUserRoleVariant,
      avatarText,
    }
  },
}
</script>
