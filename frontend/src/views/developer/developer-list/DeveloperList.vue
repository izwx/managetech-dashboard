<template>
  <div id="developer-list">
    <!-- app drawer -->
    <developer-list-add-new
      v-model="isAddNewDeveloperSidebarActive"
      @refetch-data="fetchDevelopers"
      :developer-data="developerData"
      :is-add="isAddAction"
    ></developer-list-add-new>

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
          class="developer-search me-3 mb-4"
        >
        </v-text-field>

        <v-spacer></v-spacer>

        <div class="d-flex align-center flex-wrap" v-if="$route.name == 'developer-management'">
          <v-btn color="primary" class="mb-4 me-3" @click.stop="addDeveloperData">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New Developer') }}</span>
          </v-btn>
        </div>
      </v-card-text>

      <!-- table -->
      <v-data-table
        v-model="selectedRows"
        :headers="tableColumns"
        :items="developerListTable"
        :options.sync="options"
        :server-items-length="totalDeveloperListTable"
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
        <!-- developer name -->
        <template #[`item.developer_name`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <router-link
              :to="{ name: 'developer-view', params: { id: item.id } }"
              class="font-weight-semibold text-truncate cursor-pointer text-decoration-none"
            >
              {{ item.developerName }}
            </router-link>
            <span class="text--secondary text-sm">#{{ item.id }}</span>
          </div>
        </template>

        <!-- teams -->
        <template #[`item.teams`]="{ item }">
          <span class="text--primary">{{ getTeamNames(item.teams).toString() }}</span>
        </template>

        <!-- average velocity -->
        <template #[`item.avg_velocity`]="{ item }">
          <span class="text--primary" v-if="item.avgVelocity">{{ parseFloat(item.avgVelocity).toFixed(2) }}</span>
        </template>

        <!-- average work rate -->
        <template #[`item.avg_work_rate`]="{ item }">
          <span class="text--primary" v-if="item.avgWorkRate">{{ parseFloat(item.avgWorkRate).toFixed(2) }}</span>
        </template>

        <!-- document count -->
        <template #[`item.num_documents`]="{ item }">
          <span class="text--primary" v-if="item.numDocuments">{{ item.numDocuments }}</span>
        </template>

        <!-- average lead time -->
        <template #[`item.avg_lead_time`]="{ item }">
          <span class="text--primary" v-if="item.avgLeadTime">{{ parseFloat(item.avgLeadTime).toFixed(2) }}</span>
        </template>

        <!-- average reviews -->
        <template #[`item.avg_reviews`]="{ item }">
          <span class="text--primary" v-if="item.avgReviews">{{ item.avgReviews }}</span>
        </template>

        <!-- average review hours -->
        <template #[`item.avg_review_hours`]="{ item }">
          <span class="text--primary" v-if="item.avgReviewHours">{{ parseFloat(item.avgReviewHours).toFixed(2) }}</span>
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
              <v-list-item :to="{ name: 'developer-view', params: { id: item.id } }">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiFileDocumentOutline }}
                  </v-icon>
                  <span>{{ $t('Details') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="editDeveloperData(item)" v-if="$route.name == 'developer-management'">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiPencilOutline }}
                  </v-icon>
                  <span>{{ $t('Edit') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="deleteDeveloperData(item)" v-if="$route.name == 'developer-management'">
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
import DeveloperListAddNew from './DeveloperListAddNew.vue'
import developerStoreModule from '@/store/modules/developerStoreModule'

import useDevelopersList from './useDevelopersList'

export default {
  components: {
    DeveloperListAddNew,
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

    const {
      developerListTable,
      tableColumns,
      searchQuery,
      totalDeveloperListTable,
      loading,
      options,
      selectedRows,

      fetchDevelopers,
    } = useDevelopersList()

    const developerData = ref({
      developerName: '',
      teamIds: [],
    })

    const isAddAction = ref(true)

    const addDeveloperData = () => {
      isAddAction.value = true
      isAddNewDeveloperSidebarActive.value = true
    }

    const editDeveloperData = item => {
      item.teamIds = item.teams.map(obj => obj.id)
      developerData.value = item
      isAddAction.value = false
      isAddNewDeveloperSidebarActive.value = true
    }

    const deleteDeveloperData = item => {
      store
      .dispatch('app-developer/deleteDeveloper', {
        id: item.id
      })
      .then(() => {
        fetchDevelopers()
      })
      .catch(error => {
        console.log(error)
      })
    }

    const isAddNewDeveloperSidebarActive = ref(false)

    const getTeamNames = teams => {
      return teams.map(team => team.teamName)
    }

    return {
      developerListTable,
      tableColumns,
      searchQuery,
      totalDeveloperListTable,
      loading,
      options,
      isAddNewDeveloperSidebarActive,
      selectedRows,
      avatarText,
      fetchDevelopers,

      getTeamNames,
      developerData,
      isAddAction,
      addDeveloperData,
      editDeveloperData,
      deleteDeveloperData,

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
@import '@core/preset/preset/apps/developer.scss';
</style>
