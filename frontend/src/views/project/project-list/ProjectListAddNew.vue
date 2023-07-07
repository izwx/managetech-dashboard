<template>
  <v-navigation-drawer
    :value="isAddNewProjectSidebarActive"
    temporary
    touchless
    :right="!$vuetify.rtl"
    :width="$vuetify.breakpoint.smAndUp ? 350 : '100%'"
    app
    @input="val => $emit('update:is-add-new-project-sidebar-active', val)"
  >
    <v-card height="100%">
      <div class="drawer-header d-flex align-center mb-4">
        <span class="font-weight-semibold text-base text--primary">{{
          isAdd ? $t('Add New Project') : $t('Edit Project')
        }}</span>
        <v-spacer></v-spacer>
        <v-btn icon small @click="$emit('update:is-add-new-project-sidebar-active', false)">
          <v-icon size="22">
            {{ icons.mdiClose }}
          </v-icon>
        </v-btn>
      </div>

      <v-card-text>
        <v-form ref="form" v-model="valid" @submit.prevent="onSubmit">
          <v-text-field
            v-model="newProjectData.projectName"
            :rules="[validators.required]"
            outlined
            dense
            :label="$t('Project Name')"
            :placeholder="$t('Project Name')"
            hide-details="auto"
            class="mb-6"
          ></v-text-field>

          <v-select
            v-model="newProjectData.companyId"
            :rules="[validators.requireSelected]"
            item-text="name"
            item-value="code"
            :items="companyOptions"
            :label="$t('Company')"
            :placeholder="$t('Company')"
            outlined
            dense
            clearable
            hide-details
            class="mb-6"
          ></v-select>

          <v-select
            v-model="newProjectData.clientCompanyId"
            :rules="[validators.requireSelected]"
            item-text="name"
            item-value="code"
            :items="companyOptions"
            :label="$t('Client Company')"
            :placeholder="$t('Client Company')"
            outlined
            dense
            clearable
            hide-details
            class="mb-6"
          ></v-select>

          <v-select
            v-model="newProjectData.projectPhase"
            :rules="[validators.requireSelected]"
            item-text="name"
            item-value="code"
            :items="projectPhaseOptions"
            :label="$t('Project Phase')"
            :placeholder="$t('Project Phase')"
            outlined
            dense
            clearable
            hide-details
            class="mb-6"
          >
            <template v-slot:item="{ item }">
              <span>{{ $t(item.name) }}</span>
            </template>
            <template v-slot:selection="{ item }">
              <span>{{ $t(item.name) }}</span>
            </template>
          </v-select>

          <v-text-field
            v-model="newProjectData.sprintWeek"
            v-bind:rules="[validators.integerValidator, validators.required]"
            outlined
            dense
            :label="$t('Sprint Week')"
            :placeholder="$t('Sprint Week')"
            placeholder="1スプリントは何週間か"
            hide-details="auto"
            class="mb-6"
          ></v-text-field>

          <v-text-field
            v-model="newProjectData.currentSprintOrder"
            v-bind:rules="[validators.integerValidator, validators.required]"
            outlined
            dense
            :label="$t('Current Sprint Order')"
            :placeholder="$t('Current Sprint Order')"
            hide-details="auto"
            class="mb-6"
          ></v-text-field>

          <v-text-field
            v-model="newProjectData.backlogSprintId"
            v-bind:rules="[validators.integerValidator, validators.required]"
            outlined
            dense
            :label="$t('Backlog Sprint ID')"
            :placeholder="$t('Backlog Sprint ID')"
            hide-details="auto"
            class="mb-6"
          ></v-text-field>

          <v-select
            v-model="newProjectData.projectStatus"
            :rules="[validators.requireSelected]"
            item-text="name"
            item-value="code"
            :items="projectStatusOptions"
            :label="$t('Project Status')"
            :placeholder="$t('Project Status')"
            outlined
            dense
            clearable
            hide-details
            class="mb-6"
          >
            <template v-slot:item="{ item }">
              <span>{{ $t(item.name) }}</span>
            </template>
            <template v-slot:selection="{ item }">
              <span>{{ $t(item.name) }}</span>
            </template>
          </v-select>

          <v-btn color="primary" class="me-3" type="submit">
            {{ $t('Update') }}
          </v-btn>
          <v-btn color="secondary" outlined type="reset" @click="cancelDrawer">
            {{ $t('Cancel') }}
          </v-btn>
        </v-form>
      </v-card-text>
    </v-card>
  </v-navigation-drawer>
</template>

<script>
import { mdiClose } from '@mdi/js'
import store from '@/store'
import { onUnmounted, watch, ref, computed } from '@vue/composition-api'
import { required, emailValidator, integerValidator, requireSelected } from '@core/utils/validation'
import companyStoreModule from '@/store/modules/companyStoreModule'
import projectStoreModule from '@/store/modules/projectStoreModule'

export default {
  model: {
    prop: 'isAddNewProjectSidebarActive',
    event: 'update:is-add-new-project-sidebar-active',
  },
  props: {
    isAddNewProjectSidebarActive: {
      type: Boolean,
      required: true,
    },
    projectData: {
      type: Object,
      default: () => ({}),
    },
    isAdd: {
      type: Boolean,
      required: true,
    },
  },
  setup(props, { emit }) {
    const COMPANY_STORE_MODULE_NAME = 'app-company'
    const PROJECT_STORE_MODULE_NAME = 'app-project'

    // Register module
    if (!store.hasModule(COMPANY_STORE_MODULE_NAME)) store.registerModule(COMPANY_STORE_MODULE_NAME, companyStoreModule)
    if (!store.hasModule(PROJECT_STORE_MODULE_NAME)) store.registerModule(PROJECT_STORE_MODULE_NAME, projectStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(COMPANY_STORE_MODULE_NAME)) store.unregisterModule(COMPANY_STORE_MODULE_NAME)
      if (store.hasModule(PROJECT_STORE_MODULE_NAME)) store.unregisterModule(PROJECT_STORE_MODULE_NAME)
    })

    const companyOptions = ref([])
    // fetch data
    const fetchCompanies = () => {
      store
        .dispatch('app-company/fetchCompanies', {})
        .then(response => {
          const { companies } = response.data

          companyOptions.value = companies.map(company => {
            return { code: company.id, name: company.companyName }
          })
        })
        .catch(error => {
          console.log(error)
        })
    }
    //fetch companies list on page load
    fetchCompanies()

    let projectPhases = ref({})
    // fetch data
    const fetchProjectPhases = () => {
      store
        .dispatch('app-project/fetchProjectPhases', {})
        .then(response => {
          const phases = response.data
          projectPhases.value = { ...phases }
        })
        .catch(error => {
          console.log(error)
        })
    }
    //fetch project phases list on page load
    fetchProjectPhases()

    const projectPhaseOptions = computed(() => {
      const options = []
      Object.keys(projectPhases.value).forEach(function (key) {
        options.push({
          code: projectPhases[key],
          name: key,
        })
      })
      return options
    })

    let projectStatuses = ref({})
    const fetchProjectStatuses = () => {
      store
        .dispatch('app-project/fetchProjectStatuses', {})
        .then(response => {
          const phases = response.data
          projectStatuses.value = { ...phases }
        })
        .catch(error => {
          console.log(error)
        })
    }
    //fetch project statuses list on page load
    fetchProjectStatuses()

    const projectStatusOptions = computed(() => {
      const options = []
      Object.keys(projectStatuses.value).forEach(function (key) {
        options.push({
          code: projectStatuses[key],
          name: key,
        })
      })
      return options
    })

    const blankProjectData = {
      projectName: '',
      companyId: null,
      clientCompanyId: null,
      projectPhase: 1,
      projectStatus: null,
      sprintWeek: null,
      currentSprintOrder: null,
      backlogSprintId: null,
    }

    const valid = ref(false)
    const form = ref(null)

    const validate = () => {
      form.value.validate()
    }

    const resetForm = () => {
      form.value.reset()
    }

    const newProjectData = ref(JSON.parse(JSON.stringify(blankProjectData)))

    watch(
      () => props.isAddNewProjectSidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetProjectData()
          if (!props.isAdd) {
            newProjectData.value = JSON.parse(JSON.stringify(props.projectData))
          }
          console.log('newProjectData.value: ')
          console.log(newProjectData.value)
        }
      },
    )

    const resetProjectData = () => {
      newProjectData.value = JSON.parse(JSON.stringify(blankProjectData))
      resetForm()
    }

    const cancelDrawer = () => {
      resetProjectData()
      emit('update:is-add-new-project-sidebar-active', false)
    }

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store.dispatch('app-project/addProject', newProjectData.value).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-project-sidebar-active', false)
          })
        } else {
          store.dispatch('app-project/updateProject', [newProjectData.value.id, newProjectData.value]).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-project-sidebar-active', false)
          })
        }

        resetProjectData()
      } else {
        validate()
      }
    }

    return {
      resetProjectData,
      cancelDrawer,
      form,
      onSubmit,
      newProjectData,
      valid,
      validate,

      companyOptions,
      projectPhaseOptions,
      projectStatusOptions,

      // validation
      validators: { required, emailValidator, integerValidator, requireSelected },
      icons: {
        mdiClose,
      },
    }
  },
}
</script>

<style lang="scss">
.v-navigation-drawer--temporary {
  z-index: 9;
}
</style>
