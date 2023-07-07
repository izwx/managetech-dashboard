<template>
  <div class="team-tab-developers">
    <team-tab-developers-add-new
      v-model="isAddNewSidebarActive"
      :is-add="isAddAction"
      @refetch-data="fetchTeam"
      :developer-team-data="developerTeamData"
    >
    </team-tab-developers-add-new>

    <!-- team developer list -->
    <v-card class="mb-7">
      <v-card-title class="d-flex align-center flex-wrap pb-0 mb-4">
        {{ $t('Developers') }}
        <v-spacer></v-spacer>
        <div class="d-flex align-center flex-wrap">
          <v-btn color="primary" class="me-3" @click.stop="addDeveloper">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New Developer') }}</span>
          </v-btn>
        </div>
      </v-card-title>

      <v-data-table
        :headers="developerTableHeaders"
        :items="localDeveloperTeamMapList"
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
        <!-- developer name -->
        <template #[`item.developer_name`]="{ item }">
          <div class="d-flex align-center">
            <v-avatar color="primary" class="v-avatar-light-bg primary--text" size="32">
              <v-img v-if="item.id" :src="require(`@/assets/images/avatars/${(item.id % 12) + 1}.png`)"></v-img>
              <span v-else class="font-weight-medium">{{ avatarText(item.developer.developerName) }}</span>
            </v-avatar>

            <div class="d-flex flex-column ms-3 align-center">
              <router-link
                :to="{ name: 'developer-view', params: { id: item.developer.developerId } }"
                class="text-no-wrap text-decoration-none"
              >
                <p class="font-weight-medium mb-n1">
                  {{ item.developer.developerName }}
                </p>
                <span class="text-xs text--disabled">#{{ item.developer.developerId }}</span>
              </router-link>
            </div>
          </div>
        </template>

        <!-- average velocity -->
        <template #[`item.work_hour`]="{ item }">
          {{ item.workHour }}
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
              <v-list-item @click.stop="editDeveloperData(item)">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiPencilOutline }}
                  </v-icon>
                  <span>{{ $t('Edit') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="deleteDeveloperData(item)">
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
import TeamTabDevelopersAddNew from './TeamTabDevelopersAddNew'
import developerTeamStoreModule from '@/store/modules/developerTeamStoreModule'
import teamStoreModule from '@/store/modules/teamStoreModule'

export default {
  components: {
    TeamTabDevelopersAddNew,
  },
  setup(props) {
    const DEVELOPER_TEAM_STORE_MODULE_NAME = 'app-developer-team'
    const TEAM_STORE_MODULE_NAME = 'app-team'

    // Register module
    if (!store.hasModule(DEVELOPER_TEAM_STORE_MODULE_NAME))
      store.registerModule(DEVELOPER_TEAM_STORE_MODULE_NAME, developerTeamStoreModule)
    if (!store.hasModule(TEAM_STORE_MODULE_NAME)) store.registerModule(TEAM_STORE_MODULE_NAME, teamStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(DEVELOPER_TEAM_STORE_MODULE_NAME)) store.unregisterModule(DEVELOPER_TEAM_STORE_MODULE_NAME)
      if (store.hasModule(TEAM_STORE_MODULE_NAME)) store.unregisterModule(TEAM_STORE_MODULE_NAME)
    })

    const localDeveloperTeamMapList = ref([])
    const developerTeamData = ref({})

    const developerTableHeaders = [
      { text: 'Developer Name', value: 'developer_name', sortable: false },
      { text: 'Work Hours', value: 'work_hour', sortable: false },
      { text: 'Actions', value: 'actions', align: 'right', sortable: false },
    ]

    const isAddNewSidebarActive = ref(false)
    const isAddAction = ref(true) //if add a new developer drawer, then true else false

    const addDeveloper = () => {
      isAddAction.value = true
      isAddNewSidebarActive.value = true
    }

    const deleteDeveloperData = item => {
      store
        .dispatch('app-developer-team/deleteDeveloperTeam', { id: item.id })
        .then(() => {
          fetchTeam()
        })
        .catch(error => {
          console.log(error)
        })
    }

    const editDeveloperData = item => {
      developerTeamData.value = item
      isAddAction.value = false
      isAddNewSidebarActive.value = true
    }

    const fetchTeam = () => {
      store
        .dispatch('app-team/fetchTeam', { id: router.currentRoute.params.id })
        .then(response => {
          const { team } = response.data
          localDeveloperTeamMapList.value = team.developerTeamMaps
        })
        .catch(error => {
          if (error.response.status === 404) {
            localDeveloperTeamMapList.value = []
          }
        })
    }

    fetchTeam()

    return {
      isAddNewSidebarActive,
      isAddAction,
      addDeveloper,

      developerTableHeaders,
      localDeveloperTeamMapList,

      developerTeamData,
      editDeveloperData,
      deleteDeveloperData,

      avatarText,

      fetchTeam,

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
