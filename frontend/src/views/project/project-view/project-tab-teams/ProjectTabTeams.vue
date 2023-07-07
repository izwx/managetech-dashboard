<template>
  <div class="project-tab-teams">
    <project-tab-teams-add-new
      v-model="isAddNewSidebarActive"
      :is-add="isAddAction"
      @refetch-data="fetchProject"
      :project-team-data="projectTeamData"
    >
    </project-tab-teams-add-new>

    <!-- project team list -->
    <v-card class="mb-7">
      <v-card-title class="d-flex align-center flex-wrap pb-0 mb-4">
        {{ $t('Teams') }}
        <v-spacer></v-spacer>
        <div class="d-flex align-center flex-wrap">
          <v-btn color="primary" class="me-3" @click.stop="addTeam">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New Team') }}</span>
          </v-btn>
        </div>
      </v-card-title>

      <v-data-table
        :headers="teamTableHeaders"
        :items="localProjectTeamMapList"
        hide-default-header
        hide-default-footer
      >
        <template #header="{ props: { headers } }">
          <thead class="v-data-table-header">
            <tr>
              <th
                v-for="header in headers"
                :key="header.value"
                class="text-uppercase"
                :class="{ 'text-right': header.align == 'right' }"
                scope="col"
              >
                {{ $t(header.text) }}
              </th>
            </tr>
          </thead>
        </template>
        <!-- team name -->
        <template #[`item.team_name`]="{ item }">
          <div class="d-flex align-center">
            <v-avatar color="primary" class="v-avatar-light-bg primary--text" size="32">
              <v-img v-if="item.id" :src="require(`@/assets/images/avatars/${(item.id % 12) + 1}.png`)"></v-img>
              <span v-else class="font-weight-medium">{{ avatarText(item.team.teamName) }}</span>
            </v-avatar>

            <div class="d-flex flex-column ms-3 align-center">
              <router-link
                :to="{ name: 'team-view', params: { id: item.team.teamId } }"
                class="text-no-wrap text-decoration-none"
              >
                <p class="font-weight-medium mb-n1">
                  {{ item.team.teamName }}
                </p>
                <span class="text-xs text--disabled">#{{ item.team.teamId }}</span>
              </router-link>
            </div>
          </div>
        </template>

        <!-- actions -->
        <template #[`item.actions`]="{ item }">
          <v-menu bottom left>
            <template v-slot:activator="{ on, attrs }">
              <v-btn icon v-bind="attrs" v-on="on">
                <v-icon>{{ icons.mdiDotsVertical }}</v-icon>
              </v-btn>
            </template>

            <v-list>
              <v-list-item @click.stop="editTeamData(item)">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiPencilOutline }}
                  </v-icon>
                  <span>{{ $t('Edit') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="deleteTeamData(item)">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiTrashCanOutline }}
                  </v-icon>
                  <span>{{ $t('Delete') }}</span>
                </v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </template>
      </v-data-table>
    </v-card>
  </div>
</template>

<script>
import { onUnmounted, ref, watch } from '@vue/composition-api'
import { avatarText } from '@core/utils/filter'
import store from '@/store'
import router from '@/router'
import { mdiDotsVertical, mdiPlus, mdiTrashCanOutline, mdiPencilOutline } from '@mdi/js'
import ProjectTabTeamsAddNew from './ProjectTabTeamsAddNew'
import projectTeamStoreModule from '@/store/modules/projectTeamStoreModule'
import teamStoreModule from '@/store/modules/teamStoreModule'

export default {
  components: {
    ProjectTabTeamsAddNew,
  },
  setup() {
    const DEVELOPER_TEAM_STORE_MODULE_NAME = 'app-project-team'
    const TEAM_STORE_MODULE_NAME = 'app-project'

    // Register module
    if (!store.hasModule(DEVELOPER_TEAM_STORE_MODULE_NAME))
      store.registerModule(DEVELOPER_TEAM_STORE_MODULE_NAME, projectTeamStoreModule)
    if (!store.hasModule(TEAM_STORE_MODULE_NAME)) store.registerModule(TEAM_STORE_MODULE_NAME, teamStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(DEVELOPER_TEAM_STORE_MODULE_NAME)) store.unregisterModule(DEVELOPER_TEAM_STORE_MODULE_NAME)
      if (store.hasModule(TEAM_STORE_MODULE_NAME)) store.unregisterModule(TEAM_STORE_MODULE_NAME)
    })

    const localProjectTeamMapList = ref([])
    const projectTeamData = ref({})

    const teamTableHeaders = [
      { text: 'Team Name', value: 'team_name', sortable: false },
      { text: 'Actions', value: 'actions', align: 'right', sortable: false },
    ]

    const isAddNewSidebarActive = ref(false)
    const isAddAction = ref(true) //if add a new teams drawer, then true else false

    const addTeam = () => {
      isAddAction.value = true
      isAddNewSidebarActive.value = true
    }

    const deleteTeamData = item => {
      store
        .dispatch('app-project-team/deleteProjectTeam', { id: item.id })
        .then(() => {
          fetchProject()
        })
        .catch(error => {
          console.log(error)
        })
    }

    const editTeamData = item => {
      projectTeamData.value = item
      isAddAction.value = false
      isAddNewSidebarActive.value = true
    }

    const fetchProject = () => {
      store
        .dispatch('app-project/fetchProject', { id: router.currentRoute.params.id })
        .then(response => {
          const { project } = response.data
          localProjectTeamMapList.value = project.projectTeamMaps
        })
        .catch(error => {
          if (error.response.status === 404) {
            localProjectTeamMapList.value = []
          }
        })
    }

    fetchProject()

    return {
      isAddNewSidebarActive,
      isAddAction,
      addTeam,

      teamTableHeaders,
      localProjectTeamMapList,

      projectTeamData,
      editTeamData,
      deleteTeamData,

      avatarText,

      fetchProject,

      // icons
      icons: {
        mdiDotsVertical,
        mdiPlus,
        mdiTrashCanOutline,
        mdiPencilOutline,
      },
    }
  },
}
</script>
