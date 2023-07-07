<template>
  <div id="company-list">
    <!-- app drawer -->
    <company-list-add-new
      v-model="isAddNewCompanySidebarActive"
      @refetch-data="fetchCompanies"
      :company-data="companyData"
      :is-add="isAddAction"
    ></company-list-add-new>

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
          class="company-search me-3 mb-4"
        >
        </v-text-field>

        <v-spacer></v-spacer>

        <div class="d-flex align-center flex-wrap">
          <v-btn color="primary" class="mb-4 me-3" @click.stop="addCompanyData">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New Company') }}</span>
          </v-btn>
        </div>
      </v-card-text>

      <!-- table -->
      <v-data-table
        v-model="selectedRows"
        :headers="tableColumns"
        :items="companyListTable"
        :options.sync="options"
        :server-items-length="totalCompanyListTable"
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
        <!-- company name -->
        <template #[`item.company_name`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
              {{ item.companyName }}
            </div>
            <span class="text--secondary text-sm">#{{ item.id }}</span>
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
              <v-list-item @click.stop="editCompanyData(item)">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiPencilOutline }}
                  </v-icon>
                  <span>{{ $t('Edit') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="deleteCompanyData(item)">
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
import companyStoreModule from '@/store/modules/companyStoreModule'

// sidebar
import { avatarText } from '@core/utils/filter'
import CompanyListAddNew from './CompanyListAddNew.vue'
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

import useCompaniesList from './useCompaniesList'

export default {
  components: {
    CompanyListAddNew,
  },
  setup() {
    const USER_APP_STORE_MODULE_NAME = 'app-company'

    // Register module
    if (!store.hasModule(USER_APP_STORE_MODULE_NAME))
      store.registerModule(USER_APP_STORE_MODULE_NAME, companyStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(USER_APP_STORE_MODULE_NAME)) store.unregisterModule(USER_APP_STORE_MODULE_NAME)
    })

    const {
      companyListTable,
      tableColumns,
      searchQuery,
      totalCompanyListTable,
      loading,
      options,
      selectedRows,

      fetchCompanies,
    } = useCompaniesList()

    const companyData = ref({
      companyName: '',
    })

    const isAddAction = ref(true)

    const addCompanyData = () => {
      isAddAction.value = true
      isAddNewCompanySidebarActive.value = true
    }

    const editCompanyData = item => {
      companyData.value = item
      isAddAction.value = false
      isAddNewCompanySidebarActive.value = true
    }

    const deleteCompanyData = (item) => {
      store
      .dispatch('app-company/deleteCompany', {
        id: item.id
      })
      .then(() => {
        fetchCompanies()
      })
      .catch(error => {
        console.log(error)
      })
    }

    const isAddNewCompanySidebarActive = ref(false)

    const getTeamNames = teams => {
      return teams.map(team => team.teamName)
    }

    return {
      companyListTable,
      tableColumns,
      searchQuery,
      totalCompanyListTable,
      loading,
      options,
      isAddNewCompanySidebarActive,
      selectedRows,
      avatarText,
      fetchCompanies,

      getTeamNames,
      companyData,
      isAddAction,
      addCompanyData,
      editCompanyData,
      deleteCompanyData,

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
@import '@core/preset/preset/apps/company.scss';
</style>
