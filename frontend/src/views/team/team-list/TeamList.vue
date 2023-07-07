<template>
  <div id="team-list">
    <!-- app drawer -->
    <team-list-add-new
      v-model="isAddNewTeamSidebarActive"
      @refetch-data="fetchTeams"
      :team-data="teamData"
      :is-add="isAddAction"
    ></team-list-add-new>

    <!-- search card -->
    <v-card>
      <!-- actions -->
      <v-card-text class="d-flex align-center flex-wrap pb-0">
        <!-- search -->
        <v-text-field
          v-model="searchQuery"
          :placeholder="$t('Search')"
          outlined
          hide-details
          dense
          class="team-search me-3 mb-4"
        >
        </v-text-field>

        <v-spacer></v-spacer>

        <div class="d-flex align-center flex-wrap" v-if="$route.name == 'team-management'">
          <v-btn color="primary" class="mb-4 me-3" @click.stop="addTeamData">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New Team') }}</span>
          </v-btn>
        </div>
      </v-card-text>

      <!-- table -->
      <v-data-table
        v-model="selectedRows"
        :headers="tableColumns"
        :items="teamListTable"
        :options.sync="options"
        :server-items-length="totalTeamListTable"
        :loading="loading"
        hide-default-header
        :footer-props="{
          showFirstLastPage: true,
          'items-per-page-text': $t('Rows per page'),
        }"
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
          <div class="d-flex flex-column ms-3">
            <router-link
              :to="{ name: 'team-view', params: { id: item.id } }"
              class="font-weight-semibold text-truncate cursor-pointer text-decoration-none"
            >
              {{ item.teamName }}
            </router-link>
          </div>
        </template>

        <!-- members count -->
        <template #[`item.num_members`]="{ item }">
          <div class="d-flex align-center">
            <span class="text--primary">{{ item.numMembers }}</span>
          </div>
        </template>

        <!-- average velocity -->
        <template #[`item.avg_velocity`]="{ item }">
          <span class="text--primary">{{ parseFloat(item.avgVelocity).toFixed(2) }}</span>
        </template>

        <!-- average work rate -->
        <template #[`item.avg_work_rate`]="{ item }">
          <span class="text--primary">{{ parseFloat(item.avgWorkRate).toFixed(2) }}</span>
        </template>

        <!-- document count -->
        <template #[`item.num_documents`]="{ item }">
          <span class="text--primary">{{ item.numDocuments }}</span>
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
              <v-list-item :to="{ name: 'team-view', params: { id: item.id } }">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiFileDocumentOutline }}
                  </v-icon>
                  <span>{{ $t('Details') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="editTeamData(item)" v-if="$route.name == 'team-management'">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiPencilOutline }}
                  </v-icon>
                  <span>{{ $t('Edit') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="deleteTeamData(item)" v-if="$route.name == 'team-management'">
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
// eslint-disable-next-line object-curly-newline
import {
  mdiSquareEditOutline,
  mdiDotsVertical,
  mdiPlus,
  mdiFileDocumentOutline,
  mdiPencilOutline,
  mdiTrashCanOutline,
  mdiExportVariant,
  mdiAccountOutline,
} from '@mdi/js'
import store from '@/store'
import { onUnmounted, ref } from '@vue/composition-api'

// sidebar
import { avatarText } from '@core/utils/filter'
import TeamListAddNew from './TeamListAddNew.vue'
import teamStoreModule from '@/store/modules/teamStoreModule'

import useTeamsList from './useTeamsList'

export default {
  components: {
    TeamListAddNew,
  },
  setup() {
    const USER_APP_STORE_MODULE_NAME = 'app-team'

    // Register module
    if (!store.hasModule(USER_APP_STORE_MODULE_NAME)) store.registerModule(USER_APP_STORE_MODULE_NAME, teamStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(USER_APP_STORE_MODULE_NAME)) store.unregisterModule(USER_APP_STORE_MODULE_NAME)
    })

    const {
      teamListTable,
      tableColumns,
      searchQuery,
      totalTeamListTable,
      loading,
      options,
      selectedRows,

      fetchTeams,
      resolveTeamRoleVariant,
      resolveTeamRoleIcon,
      resolveTeamStatusVariant,
      resolveTeamTotalIcon,
    } = useTeamsList()

    const teamData = ref({ teamName: '' })

    const isAddAction = ref(true)

    const addTeamData = () => {
      isAddAction.value = true
      isAddNewTeamSidebarActive.value = true
    }

    const editTeamData = item => {
      teamData.value = item
      isAddAction.value = false
      isAddNewTeamSidebarActive.value = true
    }

    const deleteTeamData = (item) => {
      store
      .dispatch('app-team/deleteTeam', {
        id: item.id
      })
      .then(() => {
        fetchTeams()
      })
      .catch(error => {
        console.log(error)
      })
    }

    const isAddNewTeamSidebarActive = ref(false)

    return {
      teamListTable,
      tableColumns,
      searchQuery,
      totalTeamListTable,
      loading,
      options,
      isAddNewTeamSidebarActive,
      selectedRows,
      avatarText,
      resolveTeamRoleVariant,
      resolveTeamRoleIcon,
      resolveTeamStatusVariant,
      resolveTeamTotalIcon,
      fetchTeams,

      teamData,
      isAddAction,
      addTeamData,
      editTeamData,
      deleteTeamData,

      // icons
      icons: {
        mdiSquareEditOutline,
        mdiFileDocumentOutline,
        mdiDotsVertical,
        mdiPencilOutline,
        mdiTrashCanOutline,
        mdiPlus,
        mdiExportVariant,
        mdiAccountOutline,
      },
    }
  },
}
</script>

<style lang="scss">
@import '@core/preset/preset/apps/team.scss';
</style>
