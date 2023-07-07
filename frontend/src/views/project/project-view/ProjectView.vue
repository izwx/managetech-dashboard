<template>
  <div id="project-view">
    <v-tabs v-model="projectTab" show-arrows background-color="transparent" class="project-tabs">
      <v-tab v-for="tab in tabs" :key="tab.icon">
        <v-icon size="20" class="me-3">
          {{ tab.icon }}
        </v-icon>
        <span>{{ $t(tab.title) }}</span>
      </v-tab>
    </v-tabs>

    <v-tabs-items id="project-tabs-content" v-model="projectTab" class="mt-5 pa-1 bg-">
      <v-tab-item>
        <project-tab-overview :project-data="projectData"></project-tab-overview>
      </v-tab-item>

      <v-tab-item>
        <project-tab-teams></project-tab-teams>
      </v-tab-item>

      <v-tab-item>
        <project-tab-notifications :notification-data="notification"></project-tab-notifications>
      </v-tab-item>
    </v-tabs-items>
  </div>
</template>

<script>
import { onUnmounted, ref } from '@vue/composition-api'
import router from '@/router'
import store from '@/store'
import projectStoreModule from '@/store/modules/projectStoreModule'

// eslint-disable-next-line object-curly-newline
import { mdiAccountOutline, mdiBellOutline, mdiAccountMultipleOutline } from '@mdi/js'
import ProjectTabOverview from './project-tab-overview/ProjectTabOverview.vue'
import ProjectTabTeams from './project-tab-teams/ProjectTabTeams'
import ProjectTabNotifications from './project-tab-notifications/ProjectTabNotifications.vue'

export default {
  components: {
    ProjectTabOverview,
    ProjectTabTeams,
    ProjectTabNotifications,
  },
  setup() {
    const USER_APP_STORE_MODULE_NAME = 'app-project'

    // Register module
    if (!store.hasModule(USER_APP_STORE_MODULE_NAME))
      store.registerModule(USER_APP_STORE_MODULE_NAME, projectStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(USER_APP_STORE_MODULE_NAME)) store.unregisterModule(USER_APP_STORE_MODULE_NAME)
    })

    const projectData = ref({})
    const projectTab = ref(null)

    const notification = ref({
      commentOnArticle: true,
      answerOnForm: true,
      followMe: false,
      newsAnnouncements: false,
      productUpdates: true,
      blogDigest: false,
    })

    store
      .dispatch('app-project/fetchProject', { id: router.currentRoute.params.id })
      .then(response => {
        const { project } = response.data
        projectData.value = JSON.parse(JSON.stringify(project))
      })
      .catch(error => {
        if (error.response.status === 404) {
          projectData.value = {}
        }
      })

    const tabs = ref([
      { icon: mdiAccountOutline, title: 'Project Detail' },
      { icon: mdiAccountMultipleOutline, title: 'Teams' },
      { icon: mdiBellOutline, title: 'Alert' },
    ])

    return {
      tabs,
      projectTab,
      projectData,
      notification,
    }
  },
}
</script>

<style lang="scss">
@import '@core/preset/preset/apps/project.scss';
</style>
