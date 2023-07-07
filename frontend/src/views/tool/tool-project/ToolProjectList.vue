<template>
  <div id="tool-project-list">
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
          class="project-search me-3 mb-4"
        >
        </v-text-field>

        <v-spacer></v-spacer>
      </v-card-text>

      <!-- table -->
      <v-data-table
        :headers="tableColumns"
        :items="projectListTable"
        :options.sync="options"
        :server-items-length="totalProjectListTable"
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
                :class="{ 'text-right': header.align == 'right' }"
                class="text-uppercase"
                scope="col"
              >
                {{ $t(header.text) }}
              </th>
            </tr>
          </thead>
        </template>
        <!-- project name -->
        <template #[`item.project_name`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <router-link
              :to="{ name: 'tool-project-view', params: { id: item.id } }"
              class="font-weight-semibold text-truncate cursor-pointer text-decoration-none"
            >
              {{ item.projectName }}
            </router-link>
          </div>
        </template>
      </v-data-table>
    </v-card>
  </div>
</template>

<script>
// eslint-disable-next-line object-curly-newline
import store from '@/store'
import { onUnmounted } from '@vue/composition-api'

// sidebar
import projectStoreModule from '@/store/modules/projectStoreModule'
import useToolProjectList from './useToolProjectList'

export default {
  setup() {
    const PROJECT_STORE_MODULE_NAME = 'app-project'

    // Register module
    if (!store.hasModule(PROJECT_STORE_MODULE_NAME)) store.registerModule(PROJECT_STORE_MODULE_NAME, projectStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(PROJECT_STORE_MODULE_NAME)) store.unregisterModule(PROJECT_STORE_MODULE_NAME)
    })

    const {
      projectListTable,
      tableColumns,
      searchQuery,
      totalProjectListTable,
      loading,
      options,

      fetchProjects,
    } = useToolProjectList()

    return {
      projectListTable,
      tableColumns,
      searchQuery,
      totalProjectListTable,
      loading,
      options,
      fetchProjects,
    }
  },
}
</script>

<style lang="scss">
#tool-project-list {
  .project-search {
    max-width: 200px;
  }
}
</style>
