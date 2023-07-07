<template>
  <div id="team-view">
    <v-tabs v-model="teamTab" show-arrows background-color="transparent" class="team-tabs">
      <v-tab v-for="tab in tabs" :key="tab.icon">
        <v-icon size="20" class="me-3">
          {{ tab.icon }}
        </v-icon>
        <span>{{ $t(tab.title) }}</span>
      </v-tab>
    </v-tabs>

    <v-tabs-items id="team-tabs-content" v-model="teamTab" class="mt-5 pa-1 bg-">
      <v-tab-item>
        <team-tab-overview :team-data="teamData"></team-tab-overview>
      </v-tab-item>

      <v-tab-item>
        <team-tab-developers></team-tab-developers>
      </v-tab-item>

      <v-tab-item>
        <team-tab-notifications :notification-data="notification"></team-tab-notifications>
      </v-tab-item>
    </v-tabs-items>
  </div>
</template>

<script>
import { onUnmounted, ref } from '@vue/composition-api'
import router from '@/router'
import store from '@/store'

// eslint-disable-next-line object-curly-newline
import { mdiAccountOutline, mdiBellOutline, mdiAccountMultipleOutline } from '@mdi/js'
import teamStoreModule from '@/store/modules/teamStoreModule'
import TeamTabOverview from './team-tab-overview/TeamTabOverview.vue'
import TeamTabDevelopers from './team-tab-developers/TeamTabDevelopers.vue'
import TeamTabNotifications from './team-tab-notifications/TeamTabNotifications.vue'

export default {
  components: {
    TeamTabOverview,
    TeamTabDevelopers,
    TeamTabNotifications,
  },
  setup() {
    const USER_APP_STORE_MODULE_NAME = 'app-team'

    // Register module
    if (!store.hasModule(USER_APP_STORE_MODULE_NAME)) store.registerModule(USER_APP_STORE_MODULE_NAME, teamStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(USER_APP_STORE_MODULE_NAME)) store.unregisterModule(USER_APP_STORE_MODULE_NAME)
    })

    const teamData = ref({ projects: [] })
    const teamTab = ref(null)

    const notification = ref({
      commentOnArticle: true,
      answerOnForm: true,
      followMe: false,
      newsAnnouncements: false,
      productUpdates: true,
      blogDigest: false,
    })

    store
      .dispatch('app-team/fetchTeam', { id: router.currentRoute.params.id })
      .then(response => {
        const { team } = response.data
        teamData.value = team
      })
      .catch(error => {
        if (error.response.status === 404) {
          teamData.value = {}
        }
      })

    const tabs = [
      { icon: mdiAccountOutline, title: 'Team Detail' },
      { icon: mdiAccountMultipleOutline, title: 'Developers' },
      { icon: mdiBellOutline, title: 'Alert' },
    ]

    return {
      tabs,
      teamTab,
      teamData,
      notification,
    }
  },
}
</script>

<style lang="scss">
@import '@core/preset/preset/apps/team.scss';
</style>
