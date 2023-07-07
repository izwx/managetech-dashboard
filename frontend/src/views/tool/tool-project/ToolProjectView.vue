<template>
  <div>
    <!-- app drawner -->
    <tool-project-add-new
      v-model="isAddNewSidebarActive"
      @refetch-data="fetchTools"
      :project-tool-list="projectToolListTable"
      :tool-data="toolData"
      :is-add="isAddAction"
    >
    </tool-project-add-new>
    <v-card>
      <!-- actions -->
      <v-card-text class="d-flex align-center flex-wrap pb-0 mb-4">
        <h3 class="text-uppercase">{{ $t('Project Name') }}: {{ projectName }}</h3>
        <v-spacer></v-spacer>
        <div class="d-flex align-center flex-wrap">
          <v-btn color="primary" class="me-3" @click.stop="addToolData">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New Tool') }}</span>
          </v-btn>
        </div>
      </v-card-text>
      <!-- table -->
      <v-data-table
        :headers="tableColumnHeaders"
        :items="projectToolListTable"
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
            {{ item.tool.toolName }}
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
import store from '@/store'
import router from '@/router'
import { ref, watch, onUnmounted } from '@vue/composition-api'
import { mdiDotsVertical, mdiFileDocumentOutline, mdiPencilOutline, mdiPlus, mdiTrashCanOutline } from '@mdi/js'
import projectStoreModule from '@/store/modules/projectStoreModule'
import projectToolStoreModule from '@/store/modules/projectToolStoreModule'
import ToolProjectAddNew from './ToolProjectAddNew.vue'

export default {
  components: {
    ToolProjectAddNew,
  },
  setup() {
    const PROJECT_STORE_MODULE_NAME = 'app-project'
    const PROJECT_TOOL_STORE_MODULE_NAME = 'app-project-tool'

    // Register module
    if (!store.hasModule(PROJECT_STORE_MODULE_NAME)) store.registerModule(PROJECT_STORE_MODULE_NAME, projectStoreModule)
    if (!store.hasModule(PROJECT_TOOL_STORE_MODULE_NAME))
      store.registerModule(PROJECT_TOOL_STORE_MODULE_NAME, projectToolStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(PROJECT_STORE_MODULE_NAME)) store.unregisterModule(PROJECT_STORE_MODULE_NAME)
      if (store.hasModule(PROJECT_TOOL_STORE_MODULE_NAME)) store.unregisterModule(PROJECT_TOOL_STORE_MODULE_NAME)
    })

    const projectName = ref('')
    const projectToolListTable = ref([])

    const tableColumnHeaders = [
      { text: 'Tool Name', value: 'tool_name' },
      { text: 'Token', value: 'token' },
      { text: 'Target', value: 'target' },
      { text: 'Payload', value: 'payload' },
      {
        text: 'Actions',
        value: 'actions',
        align: 'center',
        sortable: false,
      },
    ]
    const loading = ref(false)

    const fetchTools = () => {
      store
        .dispatch('app-project/fetchProject', { id: router.currentRoute.params.id })
        .then(response => {
          const { project } = response.data
          projectName.value = project.projectName
          projectToolListTable.value = JSON.parse(JSON.stringify(project.projectToolInfos))

          loading.value = false
        })
        .catch(error => {
          console.error(error)
        })
    }

    fetchTools()

    const toolData = ref({})
    const isAddAction = ref(true)
    const isAddNewSidebarActive = ref(false)

    const addToolData = () => {
      isAddAction.value = true
      isAddNewSidebarActive.value = true
    }

    const editToolData = item => {
      toolData.value = item
      isAddAction.value = false
      isAddNewSidebarActive.value = true
    }

    const deleteToolData = (item) => {
      store
      .dispatch('app-project-tool/deleteProjectTool', {
        id: item.id
      })
      .then(() => {
        fetchTools()
      })
      .catch(error => {
        console.log(error)
      })
    }

    return {
      fetchTools,
      projectName,
      projectToolListTable,
      tableColumnHeaders,
      loading,

      toolData,
      isAddAction,
      isAddNewSidebarActive,
      addToolData,
      editToolData,
      deleteToolData,

      // icons
      icons: {
        mdiFileDocumentOutline,
        mdiDotsVertical,
        mdiPencilOutline,
        mdiTrashCanOutline,
        mdiPlus,
      },
    }
  },
}
</script>
