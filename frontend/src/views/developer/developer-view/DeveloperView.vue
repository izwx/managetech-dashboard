<template>
  <div id="developer-view">
    <v-tabs v-model="developerTab" show-arrows background-color="transparent" class="developer-tabs">
      <v-tab v-for="tab in tabs" :key="tab.icon">
        <v-icon size="20" class="me-3">
          {{ tab.icon }}
        </v-icon>
        <span>{{ $t(tab.title) }}</span>
      </v-tab>
    </v-tabs>

    <v-tabs-items id="developer-tabs-content" v-model="developerTab" class="mt-5 pa-1 bg-">
      <v-tab-item>
        <developer-tab-overview :developer-data="developerData"></developer-tab-overview>
      </v-tab-item>

      <v-tab-item>
        <developer-tab-tools :developer-data="developerData"></developer-tab-tools>
      </v-tab-item>

      <v-tab-item>
        <developer-tab-notifications :notification-data="notification"></developer-tab-notifications>
      </v-tab-item>
    </v-tabs-items>
  </div>
</template>

<script>
import { onUnmounted, ref } from '@vue/composition-api'
import router from '@/router'
import store from '@/store'

// eslint-disable-next-line object-curly-newline
import { mdiAccountOutline, mdiTools, mdiBellOutline } from '@mdi/js'
import developerStoreModule from '@/store/modules/developerStoreModule'
import DeveloperTabOverview from './developer-tab-overview/DeveloperTabOverview.vue'
import DeveloperTabTools from './developer-tab-tools/DeveloperTabTools.vue'
import DeveloperTabNotifications from './developer-tab-notifications/DeveloperTabNotifications.vue'
import { getCurrentInstance } from '@vue/composition-api'

export default {
  components: {
    DeveloperTabOverview,
    DeveloperTabTools,
    DeveloperTabNotifications,
  },
  setup() {
    const USER_APP_STORE_MODULE_NAME = 'app-developer'

    // Register module
    if (!store.hasModule(USER_APP_STORE_MODULE_NAME))
      store.registerModule(USER_APP_STORE_MODULE_NAME, developerStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(USER_APP_STORE_MODULE_NAME)) store.unregisterModule(USER_APP_STORE_MODULE_NAME)
    })

    const developerData = ref({})
    const developerTab = ref(null)

    const notification = ref({
      commentOnArticle: true,
      answerOnForm: true,
      followMe: false,
      newsAnnouncements: false,
      productUpdates: true,
      blogDigest: false,
    })

    store
      .dispatch('app-developer/fetchDeveloper', { id: router.currentRoute.params.id })
      .then(response => {
        const { developer } = response.data
        developerData.value = developer
      })
      .catch(error => {
        if (error.response.status === 404) {
          developerData.value = {}
        }
      })

    const tabs = [
      { icon: mdiAccountOutline, title: 'Developer Detail' },
      { icon: mdiTools, title: 'Tools' },
      { icon: mdiBellOutline, title: 'Alert' },
    ]

    // Only display tool tab if the user has permission of developer_management
    const vm = getCurrentInstance().proxy
    if (!vm.$can('all', 'developer_management')) {
      tabs.splice(1, 1)
    }

    return {
      tabs,
      developerTab,
      developerData,
      notification,
    }
  },
}
</script>

<style lang="scss">
@import '@core/preset/preset/apps/developer.scss';
</style>
