<template>
  <v-menu offset-y left nudge-bottom="14" min-width="230" content-class="user-profile-menu-content" v-model="isOpened">
    <template v-slot:activator="{ on, attrs }">
      <v-badge bottom color="success" overlap offset-x="12" offset-y="12" class="ms-4" dot>
        <v-avatar size="40px" v-bind="attrs" color="primary" class="v-avatar-light-bg primary--text" v-on="on">
          <v-img v-if="userData && userData.avatar_url" :src="userData.avatar_url"></v-img>
          <v-icon v-else color="primary" size="28">
            {{ icons.mdiAccountOutline }}
          </v-icon>
        </v-avatar>
      </v-badge>
    </template>
    <v-list>
      <div class="pb-3 pt-2">
        <v-badge bottom color="success" overlap offset-x="12" offset-y="12" class="ms-4" dot>
          <v-avatar size="40px" color="primary" class="v-avatar-light-bg primary--text">
            <v-img v-if="userData && userData.avatar_url" :src="userData.avatar_url"></v-img>
            <v-icon v-else color="primary" size="28">
              {{ icons.mdiAccountOutline }}
            </v-icon>
          </v-avatar>
        </v-badge>
        <div class="d-inline-flex flex-column justify-center ms-3" style="vertical-align: middle">
          <span class="text--primary font-weight-semibold mb-n1" v-if="userData">
            {{ userData.name }}
          </span>
          <small class="text--disabled text-capitalize">{{ userData.role }}</small>
        </div>
      </div>

      <v-divider class="my-2"></v-divider>

      <!-- Settings -->
      <v-list-item :to="{ name: 'password-setting' }">
        <v-list-item-icon class="me-2">
          <v-icon size="22">
            {{ icons.mdiCogOutline }}
          </v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>{{ $t('userMenu.setting') }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-divider class="my-2"></v-divider>

      <!-- Logout -->
      <v-list-item @click="logoutUser">
        <v-list-item-icon class="me-2">
          <v-icon size="22">
            {{ icons.mdiLogoutVariant }}
          </v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>{{ $t('userMenu.logout') }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>
  </v-menu>
</template>

<script>
import {
  mdiAccountOutline,
  mdiEmailOutline,
  mdiCheckboxMarkedOutline,
  mdiChatOutline,
  mdiCogOutline,
  mdiCurrencyUsd,
  mdiHelpCircleOutline,
  mdiLogoutVariant,
} from '@mdi/js'
import { useRouter } from '@core/utils'
import { initialAbility } from '@/plugins/acl/config'
import { ref, watch, getCurrentInstance } from '@vue/composition-api'
import store from '@/store'

export default {
  setup() {
    const vm = getCurrentInstance().proxy
    const { router } = useRouter()
    const userData = ref(JSON.parse(localStorage.getItem('userData')))

    const isOpened = ref(false)
    watch(isOpened, val => {
      // if app bar user menu is opened
      if (isOpened) {
        userData.value = JSON.parse(localStorage.getItem('userData'))
      }
    })

    const logoutUser = async () => {
      try {
        await store.dispatch('logoutUser')
      } catch (e) {
        console.log(e)
      } finally {
        // Reset ability
        vm.$ability.update(initialAbility)

        // Redirect to login page
        router.push({ name: 'auth-login' })
      }
    }

    return {
      logoutUser,
      userData,
      isOpened,

      icons: {
        mdiAccountOutline,
        mdiEmailOutline,
        mdiCheckboxMarkedOutline,
        mdiChatOutline,
        mdiCogOutline,
        mdiCurrencyUsd,
        mdiHelpCircleOutline,
        mdiLogoutVariant,
      },
    }
  },
}
</script>

<style lang="scss">
.user-profile-menu-content {
  .v-list-item {
    min-height: 2.5rem !important;
  }
}
</style>
