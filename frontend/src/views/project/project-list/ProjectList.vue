<template>
  <div id="project-list">
    <!-- app drawer -->
    <project-list-add-new
      v-model="isAddNewProjectSidebarActive"
      @refetch-data="fetchProjects"
      :project-data="projectData"
      :is-add="isAddAction"
    ></project-list-add-new>

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

        <div class="d-flex align-center flex-wrap" v-if="$route.name == 'project-management'">
          <v-btn color="primary" class="mb-4 me-3" @click.stop="addProjectData">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New Project') }}</span>
          </v-btn>
        </div>
      </v-card-text>

      <!-- table -->
      <v-data-table
        v-model="selectedRows"
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
                class="text-uppercase"
                :class="{ 'text-right': header.align == 'right' }"
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
              :to="{ name: 'project-view', params: { id: item.id } }"
              class="font-weight-semibold text-truncate cursor-pointer text-decoration-none"
            >
              {{ item.projectName }}
            </router-link>
          </div>
        </template>

        <!-- company name -->
        <template #[`item.company_name`]="{ item }">
          <div class="d-flex align-center">
            <span class="text--primary">{{ item.company.companyName }}</span>
          </div>
        </template>

        <!-- project phase -->
        <template #[`item.project_phase`]="{ item }">
          <v-chip
            small
            :color="phaseColor[item.projectPhase]"
            :class="`${phaseColor[item.projectPhase]}--text`"
            class="v-chip-light-bg font-weight-semibold text-capitalize"
          >
            {{ $t(`${item.projectPhase}`) }}
          </v-chip>
        </template>

        <!-- progress_rate -->
        <template #[`item.progress_rate`]="{ item }">
          <span>{{ parseFloat(item.progressRate).toFixed(2) }}%</span>
          <v-progress-linear
            height="6"
            rounded
            class="project-progress mt-1"
            :color="resolveProgressVariant(item.progressRate)"
            :value="parseFloat(item.progressRate).toFixed(2)"
          ></v-progress-linear>
        </template>

        <!-- project status -->
        <template #[`item.project_status`]="{ item }">
          <v-chip
            small
            :color="statusColor[item.projectStatus]"
            :class="`${statusColor[item.projectStatus]}--text`"
            class="v-chip-light-bg font-weight-semibold text-capitalize"
          >
            {{ $t(`${item.projectStatus}`) }}
          </v-chip>
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
              <v-list-item :to="{ name: 'project-view', params: { id: item.id } }">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiFileDocumentOutline }}
                  </v-icon>
                  <span>{{ $t('Details') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="editProjectData(item)" v-if="$route.name == 'project-management'">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiPencilOutline }}
                  </v-icon>
                  <span>{{ $t('Edit') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="deleteProjectData(item)" v-if="$route.name == 'project-management'">
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
  mdiDotsVertical,
  mdiPlus,
  mdiFileDocumentOutline,
  mdiPencilOutline,
  mdiTrashCanOutline,
} from '@mdi/js'
import store from '@/store'
import { onUnmounted, ref } from '@vue/composition-api'

// sidebar
import { avatarText } from '@core/utils/filter'
import ProjectListAddNew from './ProjectListAddNew.vue'
import projectStoreModule from '@/store/modules/projectStoreModule'
import useProjectsList from './useProjectsList'

export default {
  components: {
    ProjectListAddNew,
  },
  setup() {
    const PROJECT_STORE_MODULE_NAME = 'app-project'
    // Register module
    if (!store.hasModule(PROJECT_STORE_MODULE_NAME)) store.registerModule(PROJECT_STORE_MODULE_NAME, projectStoreModule)
    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(PROJECT_STORE_MODULE_NAME)) store.unregisterModule(PROJECT_STORE_MODULE_NAME)
    })

    const phaseColor = {
      /* eslint-disable key-spacing */
      new: 'info',
      maintenance: 'warning',
      update: 'error',
      /* eslint-enable key-spacing */
    }

    const statusColor = {
      /* eslint-disable key-spacing */
      active: 'success',
      inactive: 'disabled',
    }

    const {
      projectListTable,
      tableColumns,
      resolveProgressVariant,
      searchQuery,
      totalProjectListTable,
      loading,
      options,
      selectedRows,

      fetchProjects,
    } = useProjectsList()

    const projectData = ref({
      projectName: '',
      companyId: 0,
      projectPhase: 1,
      sprintWeek: '',
      backlogSprintId: '',
    })

    const isAddAction = ref(true)

    const addProjectData = () => {
      isAddAction.value = true
      isAddNewProjectSidebarActive.value = true
    }

    const editProjectData = item => {
      projectData.value = item
      isAddAction.value = false
      isAddNewProjectSidebarActive.value = true
    }

    const deleteProjectData = (item) => {
      store
      .dispatch('app-project/deleteProject', {
        id: item.id
      })
      .then(() => {
        fetchProjects()
      })
      .catch(error => {
        console.log(error)
      })
    }

    const isAddNewProjectSidebarActive = ref(false)

    return {
      phaseColor,
      statusColor,
      projectListTable,
      tableColumns,
      resolveProgressVariant,
      searchQuery,
      totalProjectListTable,
      loading,
      options,
      isAddNewProjectSidebarActive,
      selectedRows,
      avatarText,
      fetchProjects,

      projectData,
      isAddAction,
      addProjectData,
      editProjectData,
      deleteProjectData,

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

<style lang="scss">
@import '@core/preset/preset/apps/project.scss';
</style>
