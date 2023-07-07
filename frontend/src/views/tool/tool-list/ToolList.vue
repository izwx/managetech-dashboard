<template>
  <div id="tool-list">
    <!-- app drawer -->
    <tool-list-add-new
      v-model="isAddNewToolSidebarActive"
      @refetch-data="fetchTools"
      :tool-data="toolData"
      :is-add="isAddAction"
    ></tool-list-add-new>

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
          class="tool-search me-3 mb-4"
        >
        </v-text-field>

        <v-spacer></v-spacer>

        <div class="d-flex align-center flex-wrap">
          <v-btn color="primary" class="mb-4 me-3" @click.stop="addToolData">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New Tool') }}</span>
          </v-btn>
        </div>
      </v-card-text>

      <!-- table -->
      <v-data-table
        v-model="selectedRows"
        :headers="tableColumns"
        :items="toolListTable"
        :options.sync="options"
        :server-items-length="totalToolListTable"
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
        <!-- tool name -->
        <template #[`item.tool_name`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
              {{ item.toolName }}
            </div>
            <span class="text--secondary text-sm">#{{ item.id }}</span>
          </div>
        </template>
        <!-- token guide -->
        <template #[`item.token_guide`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary">
              {{ item.tokenGuide }}
            </div>
          </div>
        </template>
        <!-- target guide -->
        <template #[`item.target_guide`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary">
              {{ item.targetGuide }}
            </div>
          </div>
        </template>
        <!-- payload guide -->
        <template #[`item.payload_guide`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary">
              {{ item.payloadGuide }}
            </div>
          </div>
        </template>
        <!-- account name guide -->
        <template #[`item.account_name_guide`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary">
              {{ item.accountNameGuide }}
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
              <v-list-item @click.stop="editToolData(item)">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiPencilOutline }}
                  </v-icon>
                  <span>{{ $t('Edit') }}</span>
                </v-list-item-title>
              </v-list-item>
              <v-list-item @click.stop="deleteToolData(item)">
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
import toolStoreModule from '@/store/modules/toolStoreModule'

// sidebar
import { avatarText } from '@core/utils/filter'
import ToolListAddNew from './ToolListAddNew.vue'
// eslint-disable-next-line object-curly-newline
import { mdiDotsVertical, mdiPlus, mdiPencilOutline, mdiTrashCanOutline } from '@mdi/js'

import useToolsList from './useToolsList'

export default {
  components: {
    ToolListAddNew,
  },
  setup() {
    const TOOL_STORE_MODULE_NAME = 'app-tool'

    // Register module
    if (!store.hasModule(TOOL_STORE_MODULE_NAME)) store.registerModule(TOOL_STORE_MODULE_NAME, toolStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(TOOL_STORE_MODULE_NAME)) store.unregisterModule(TOOL_STORE_MODULE_NAME)
    })

    const {
      toolListTable,
      tableColumns,
      searchQuery,
      totalToolListTable,
      loading,
      options,
      selectedRows,

      fetchTools,
    } = useToolsList()

    const toolData = ref({
      toolName: '',
    })

    const isAddAction = ref(true)

    const addToolData = () => {
      isAddAction.value = true
      isAddNewToolSidebarActive.value = true
    }

    const editToolData = item => {
      toolData.value = item
      isAddAction.value = false
      isAddNewToolSidebarActive.value = true
    }

    const deleteToolData = item => {
      store
        .dispatch('app-tool/deleteTool', { id: item.id })
        .then(response => {
          fetchTools()
        })
        .catch(error => {
          alert("Can't delete the tool.")
        })
    }

    const isAddNewToolSidebarActive = ref(false)

    const getTeamNames = teams => {
      return teams.map(team => team.teamName)
    }

    return {
      toolListTable,
      tableColumns,
      searchQuery,
      totalToolListTable,
      loading,
      options,
      isAddNewToolSidebarActive,
      selectedRows,
      avatarText,
      fetchTools,

      getTeamNames,
      toolData,
      isAddAction,
      addToolData,
      editToolData,
      deleteToolData,

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
@import '@core/preset/preset/apps/tool.scss';
</style>
