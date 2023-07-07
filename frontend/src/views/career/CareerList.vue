<template>
  <div id="career-list">
    <!-- app drawer -->
    <career-list-add-new
      v-model="isAddNewCareerSidebarActive"
      @refetch-data="fetchCareers"
      :career-data="careerData"
      :is-add="isAddAction"
    ></career-list-add-new>

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
          class="career-search me-3 mb-4"
        >
        </v-text-field>

        <v-spacer></v-spacer>

        <div class="d-flex align-center flex-wrap">
          <v-btn color="primary" class="mb-4 me-3" @click.stop="addCareerData">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New Career') }}</span>
          </v-btn>
        </div>
      </v-card-text>

      <!-- table -->
      <v-data-table
        v-model="selectedRows"
        :headers="tableColumns"
        :items="careerListTable"
        :options.sync="options"
        :server-items-length="totalCareerListTable"
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
            <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
              {{ item.developer.developerName }}
            </div>
            <span class="text--secondary text-sm">#{{ item.id }}</span>
          </div>
        </template>

        <!-- start month -->
        <template #[`item.start_month`]="{ item }">
          <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
            {{ item.startMonth }}
          </div>
        </template>

        <!-- end month -->
        <template #[`item.end_month`]="{ item }">
          <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
            {{ item.endMonth }}
          </div>
        </template>

        <!-- project name -->
        <template #[`item.project_name`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
              {{ item.project.projectName || '' }}
            </div>
          </div>
        </template>

        <!-- role -->
        <template #[`item.role`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
              {{ item.role }}
            </div>
          </div>
        </template>

        <!-- actions -->
        <template #[`item.actions`]="{ item }">
          <v-menu bottom right>
            <template v-slot:activator="{ on, attrs }">
              <v-btn icon v-bind="attrs" v-on="on">
                <v-icon>{{ icons.mdiDotsVertical }}</v-icon>
              </v-btn>
            </template>

            <v-list>
              <v-list-item @click.stop="editCareerData(item)">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiPencilOutline }}
                  </v-icon>
                  <span>{{ $t('Edit') }}</span>
                </v-list-item-title>
              </v-list-item>
              <v-list-item @click.stop="deleteCareerData(item)">
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
import { onUnmounted, ref } from '@vue/composition-api'
import store from '@/store'
import careerStoreModule from '@/store/modules/careerStoreModule'

// sidebar
import { avatarText } from '@core/utils/filter'
import CareerListAddNew from './CareerListAddNew.vue'
// eslint-disable-next-line object-curly-newline
import { mdiDotsVertical, mdiPlus, mdiPencilOutline, mdiTrashCanOutline } from '@mdi/js'

import useCareersList from './useCareersList'

export default {
  components: {
    CareerListAddNew,
  },
  setup() {
    const CAREER_STORE_MODULE_NAME = 'app-career'

    // Register module
    if (!store.hasModule(CAREER_STORE_MODULE_NAME)) store.registerModule(CAREER_STORE_MODULE_NAME, careerStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(CAREER_STORE_MODULE_NAME)) store.unregisterModule(CAREER_STORE_MODULE_NAME)
    })

    const {
      careerListTable,
      tableColumns,
      searchQuery,
      totalCareerListTable,
      loading,
      options,
      selectedRows,

      fetchCareers,
      resolveUserRoleVariant,
      resolveUserRoleIcon,
    } = useCareersList()

    const careerData = ref({
      careerName: '',
      projectId: null,
      developerId: null,
      startMonth: null,
      endMonth: null,
      role: null,
    })

    const isAddAction = ref(true)

    const addCareerData = () => {
      isAddAction.value = true
      isAddNewCareerSidebarActive.value = true
    }

    const editCareerData = item => {
      careerData.value = item
      isAddAction.value = false
      isAddNewCareerSidebarActive.value = true
    }

    const deleteCareerData = item => {
      store
        .dispatch('app-career/deleteCareer', { id: item.id })
        .then(response => {
          fetchCareers()
        })
        .catch(error => {
          alert("Can't delete the career.")
        })
    }

    const isAddNewCareerSidebarActive = ref(false)

    const getTeamNames = teams => {
      return teams.map(team => team.teamName)
    }

    return {
      careerListTable,
      tableColumns,
      searchQuery,
      totalCareerListTable,
      loading,
      options,
      isAddNewCareerSidebarActive,
      selectedRows,
      avatarText,
      fetchCareers,
      resolveUserRoleVariant,
      resolveUserRoleIcon,

      getTeamNames,
      careerData,
      isAddAction,
      addCareerData,
      editCareerData,
      deleteCareerData,

      // icons
      icons: {
        mdiDotsVertical,
        mdiPencilOutline,
        mdiPlus,
        mdiTrashCanOutline,
      },
    }
  },
}
</script>

<style lang="scss">
@import '@core/preset/preset/apps/career.scss';
</style>
