<template>
  <div id="domain-list">
    <!-- app drawer -->
    <domain-list-add-new
      v-model="isAddNewDomainSidebarActive"
      @refetch-data="fetchDomains"
      :domain-data="domainData"
      :is-add="isAddAction"
    ></domain-list-add-new>

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
          class="domain-search me-3 mb-4"
        >
        </v-text-field>

        <v-spacer></v-spacer>

        <div class="d-flex align-center flex-wrap">
          <v-btn color="primary" class="mb-4 me-3" @click.stop="addDomainData">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New Domain') }}</span>
          </v-btn>
        </div>
      </v-card-text>

      <!-- table -->
      <v-data-table
        v-model="selectedRows"
        :headers="tableColumns"
        :items="domainListTable"
        :options.sync="options"
        :server-items-length="totalDomainListTable"
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
        <!-- domain name -->
        <template #[`item.domain_name`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
              {{ item.domainName }}
            </div>
            <span class="text--secondary text-sm">#{{ item.id }}</span>
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

        <!-- creater name -->
        <template #[`item.creater`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
              {{ item.creater.email || '' }}
            </div>
            <div class="d-flex align-center">
              <v-chip
                small
                :color="resolveUserRoleVariant(item.creater.role)"
                :class="`${resolveUserRoleVariant(item.creater.role)}--text`"
                class="v-chip-light-bg font-weight-semibold text-capitalize"
                v-if="item.creater.role"
              >
                <span class="text-xs">{{ $t(`${item.creater.role}`) }}</span>
              </v-chip>
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
              <v-list-item @click.stop="editDomainData(item)">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiPencilOutline }}
                  </v-icon>
                  <span>{{ $t('Edit') }}</span>
                </v-list-item-title>
              </v-list-item>
              <v-list-item @click.stop="deleteDomainData(item)">
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
import domainStoreModule from '@/store/modules/domainStoreModule'

// sidebar
import { avatarText } from '@core/utils/filter'
import DomainListAddNew from './DomainListAddNew.vue'
// eslint-disable-next-line object-curly-newline
import { mdiDotsVertical, mdiPlus, mdiPencilOutline, mdiTrashCanOutline } from '@mdi/js'

import useDomainsList from './useDomainsList'

export default {
  components: {
    DomainListAddNew,
  },
  setup() {
    const DOMAIN_STORE_MODULE_NAME = 'app-domain'

    // Register module
    if (!store.hasModule(DOMAIN_STORE_MODULE_NAME)) store.registerModule(DOMAIN_STORE_MODULE_NAME, domainStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(DOMAIN_STORE_MODULE_NAME)) store.unregisterModule(DOMAIN_STORE_MODULE_NAME)
    })

    const {
      domainListTable,
      tableColumns,
      searchQuery,
      totalDomainListTable,
      loading,
      options,
      selectedRows,

      fetchDomains,
      resolveUserRoleVariant,
      resolveUserRoleIcon,
    } = useDomainsList()

    const domainData = ref({
      domainName: '',
      projectId: null,
    })

    const isAddAction = ref(true)

    const addDomainData = () => {
      isAddAction.value = true
      isAddNewDomainSidebarActive.value = true
    }

    const editDomainData = item => {
      domainData.value = item
      isAddAction.value = false
      isAddNewDomainSidebarActive.value = true
    }

    const deleteDomainData = item => {
      store
        .dispatch('app-domain/deleteDomain', { id: item.id })
        .then(response => {
          fetchDomains()
        })
        .catch(error => {
          alert("Can't delete the domain.")
        })
    }

    const isAddNewDomainSidebarActive = ref(false)

    const getTeamNames = teams => {
      return teams.map(team => team.teamName)
    }

    return {
      domainListTable,
      tableColumns,
      searchQuery,
      totalDomainListTable,
      loading,
      options,
      isAddNewDomainSidebarActive,
      selectedRows,
      avatarText,
      fetchDomains,
      resolveUserRoleVariant,
      resolveUserRoleIcon,

      getTeamNames,
      domainData,
      isAddAction,
      addDomainData,
      editDomainData,
      deleteDomainData,

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
@import '@core/preset/preset/apps/domain.scss';
</style>
