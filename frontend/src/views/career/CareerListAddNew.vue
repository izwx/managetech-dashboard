<template>
  <v-navigation-drawer
    :value="isAddNewCareerSidebarActive"
    temporary
    touchless
    :right="!$vuetify.rtl"
    :width="$vuetify.breakpoint.smAndUp ? 350 : '100%'"
    app
    @input="val => $emit('update:is-add-new-career-sidebar-active', val)"
  >
    <v-card height="100%">
      <div class="drawer-header d-flex align-center mb-4">
        <span class="font-weight-semibold text-base text--primary">{{
          isAdd ? $t('Add New Career') : $t('Edit Career')
        }}</span>
        <v-spacer></v-spacer>
        <v-btn icon small @click="$emit('update:is-add-new-career-sidebar-active', false)">
          <v-icon size="22">
            {{ icons.mdiClose }}
          </v-icon>
        </v-btn>
      </div>

      <v-card-text>
        <v-form ref="form" v-model="valid" @submit.prevent="onSubmit">
          <v-row>
            <!-- Developer List -->
            <v-col cols="12">
              <v-autocomplete
                v-model="newCareerData.developerId"
                :items="developerList"
                item-text="developerName"
                item-value="id"
                outlined
                dense
                hide-details="auto"
                :label="$t('Developer')"
                :disabled="!isAdd"
              ></v-autocomplete>
            </v-col>

            <!-- Project List -->
            <v-col cols="12">
              <v-autocomplete
                v-model="newCareerData.projectId"
                :items="projectList"
                item-text="projectName"
                item-value="id"
                outlined
                dense
                hide-details="auto"
                :label="$t('Project')"
              ></v-autocomplete>
            </v-col>

            <!-- Start Month -->
            <v-col cols="12">
              <v-menu
                v-model="menu1"
                :close-on-content-click="false"
                transition="scale-transition"
                offset-y
                min-width="auto"
              >
                <template v-slot:activator="{ on, attrs }">
                  <v-text-field
                    v-model="newCareerData.startMonth"
                    :label="$t('Start Month')"
                    :placeholder="$t('Start Month')"
                    :append-icon="icons.mdiCalendar"
                    readonly
                    outlined
                    dense
                    hide-details="auto"
                    v-bind="attrs"
                    v-on="on"
                  ></v-text-field>
                </template>
                <v-date-picker
                  v-model="newCareerData.startMonth"
                  no-title
                  color="primary"
                  @input="menu1 = false"
                ></v-date-picker>
              </v-menu>
            </v-col>

            <!-- End Month -->
            <v-col cols="12">
              <v-menu
                v-model="menu2"
                :close-on-content-click="false"
                transition="scale-transition"
                offset-y
                min-width="auto"
              >
                <template v-slot:activator="{ on, attrs }">
                  <v-text-field
                    v-model="newCareerData.endMonth"
                    :label="$t('End Month')"
                    :placeholder="$t('End Month')"
                    :append-icon="icons.mdiCalendar"
                    readonly
                    outlined
                    dense
                    hide-details="auto"
                    v-bind="attrs"
                    v-on="on"
                  ></v-text-field>
                </template>
                <v-date-picker
                  v-model="newCareerData.endMonth"
                  no-title
                  color="primary"
                  @input="menu2 = false"
                ></v-date-picker>
              </v-menu>
            </v-col>

            <!-- Role Options -->
            <v-col cols="12" sm="12">
              <v-select
                v-model="newCareerData.role"
                :items="roleOptions"
                :label="$t('Role')"
                item-text="title"
                item-value="value"
                outlined
                clearable
                dense
                hide-details="auto"
              ></v-select>
            </v-col>

            <v-col md="12" cols="12">
              <v-select
                v-model="newCareerData.skillIds"
                item-text="skillName"
                item-value="id"
                :items="skillListTable"
                :label="$t('Skill Name')"
                :placeholder="$t('Skill Name')"
                outlined
                multiple
                chips
                clearable
                dense
                hide-details
              ></v-select>
            </v-col>

            <v-col md="12" cols="12">
              <v-select
                v-model="newCareerData.domainIds"
                item-text="domainName"
                item-value="id"
                :items="domainListTable"
                :label="$t('Domain Name')"
                :placeholder="$t('Domain Name')"
                outlined
                multiple
                chips
                clearable
                dense
                hide-details
              ></v-select>
            </v-col>

            <v-col md="12" cols="12">
              <v-btn color="primary" class="me-3" type="submit">
                {{ $t('Update') }}
              </v-btn>
              <v-btn color="secondary" outlined type="reset" @click="cancelDrawer">
                {{ $t('Cancel') }}
              </v-btn>
            </v-col>
          </v-row>
        </v-form>
      </v-card-text>
    </v-card>
  </v-navigation-drawer>
</template>

<script>
import { mdiClose, mdiCalendar } from '@mdi/js'
import store from '@/store'
import { onUnmounted, ref, watch } from '@vue/composition-api'
import { required, emailValidator } from '@core/utils/validation'
import careerStoreModule from '@/store/modules/careerStoreModule'
import projectStoreModule from '@/store/modules/projectStoreModule'
import developerStoreModule from '@/store/modules/developerStoreModule'
import skillStoreModule from '@/store/modules/skillStoreModule'
import domainStoreModule from '@/store/modules/domainStoreModule'
import useCareersList from './useCareersList'

export default {
  model: {
    prop: 'isAddNewCareerSidebarActive',
    event: 'update:is-add-new-career-sidebar-active',
  },
  props: {
    isAddNewCareerSidebarActive: {
      type: Boolean,
      required: true,
    },
    careerData: {
      type: Object,
      default: () => ({}),
    },
    isAdd: {
      type: Boolean,
      required: true,
    },
  },
  setup(props, { emit }) {
    const CAREER_STORE_MODULE_NAME = 'app-career'
    const PROJECT_STORE_MODULE_NAME = 'app-project'
    const DEVELOPER_STORE_MODULE_NAME = 'app-developer'
    const SKILL_STORE_MODULE_NAME = 'app-skill'
    const DOMAIN_STORE_MODULE_NAME = 'app-domain'

    // Register module
    if (!store.hasModule(CAREER_STORE_MODULE_NAME)) store.registerModule(CAREER_STORE_MODULE_NAME, careerStoreModule)
    if (!store.hasModule(PROJECT_STORE_MODULE_NAME)) store.registerModule(PROJECT_STORE_MODULE_NAME, projectStoreModule)
    if (!store.hasModule(DEVELOPER_STORE_MODULE_NAME))
      store.registerModule(DEVELOPER_STORE_MODULE_NAME, developerStoreModule)
    if (!store.hasModule(SKILL_STORE_MODULE_NAME)) store.registerModule(SKILL_STORE_MODULE_NAME, skillStoreModule)
    if (!store.hasModule(DOMAIN_STORE_MODULE_NAME)) store.registerModule(DOMAIN_STORE_MODULE_NAME, domainStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(CAREER_STORE_MODULE_NAME)) store.unregisterModule(CAREER_STORE_MODULE_NAME)
      if (store.hasModule(PROJECT_STORE_MODULE_NAME)) store.unregisterModule(PROJECT_STORE_MODULE_NAME)
      if (store.hasModule(DEVELOPER_STORE_MODULE_NAME)) store.unregisterModule(DEVELOPER_STORE_MODULE_NAME)
      if (store.hasModule(SKILL_STORE_MODULE_NAME)) store.unregisterModule(SKILL_STORE_MODULE_NAME)
      if (store.hasModule(DOMAIN_STORE_MODULE_NAME)) store.unregisterModule(DOMAIN_STORE_MODULE_NAME)
    })

    const { userRole, userId, companyId } = useCareersList()

    // Fetching project list
    const projectList = ref([])
    store
      .dispatch('app-project/fetchProjects', {
        options: {
          sortBy: ['id'],
          sortDesc: [true],
          itemsPerPage: -1,
        },
        companyId,
      })
      .then(response => {
        const { projects } = response.data
        projectList.value = JSON.parse(JSON.stringify(projects))
      })
      .catch(error => {
        console.error(error)
      })

    // Fetching developers list
    const developerList = ref([])
    store
      .dispatch('app-developer/fetchDevelopers', {
        options: {
          sortBy: ['id'],
          sortDesc: [true],
          itemsPerPage: -1,
        },
        ...(userRole == 'projectManager' ? { companyId } : userRole == 'developer' ? { userId } : {}),
      })
      .then(response => {
        const { developers } = response.data
        developerList.value = JSON.parse(JSON.stringify(developers))
      })
      .catch(error => {
        console.error(error)
      })

    const menu1 = ref(false)
    const menu2 = ref(false)

    const blankCareerData = {
      projectId: null,
      developerId: null,
      startMonth: new Date().toISOString(),
      endMonth: new Date().toISOString(),
      role: null,
      skillIds: [],
      domainIds: [],
    }

    const valid = ref(false)
    const form = ref(null)

    const validate = () => {
      form.value.validate()
    }

    const resetForm = () => {
      form.value.reset()
    }

    const newCareerData = ref(JSON.parse(JSON.stringify(blankCareerData)))

    watch(
      () => props.isAddNewCareerSidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetCareerData()
          if (!props.isAdd) {
            const localCareerData = props.careerData
            localCareerData.projectId = props.careerData.project?.projectId || 0
            localCareerData.developerId = props.careerData.developer?.developerId
            localCareerData.skillIds = props.careerData.skills.map(s => s.id)
            localCareerData.domainIds = props.careerData.domains.map(d => d.id)
            newCareerData.value = JSON.parse(JSON.stringify(localCareerData))
          }
        }
      },
    )

    const resetCareerData = () => {
      newCareerData.value = JSON.parse(JSON.stringify(blankCareerData))
      resetForm()
    }

    const cancelDrawer = () => {
      resetCareerData()
      emit('update:is-add-new-career-sidebar-active', false)
    }

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store.dispatch('app-career/addCareer', newCareerData.value).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-career-sidebar-active', false)
          })
        } else {
          store.dispatch('app-career/updateCareer', [newCareerData.value.id, newCareerData.value]).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-career-sidebar-active', false)
          })
        }

        resetCareerData()
      } else {
        validate()
      }
    }

    const roleOptions = [
      { title: 'コーダー', value: 'coder' },
      { title: 'マネージャ', value: 'manager' },
      { title: 'TL', value: 'tl' },
    ]

    const skillListTable = ref([])
    const fetchSkills = () => {
      store
        .dispatch('app-skill/fetchAllSkills')
        .then(response => {
          const { skillMasters } = response.data

          skillListTable.value = JSON.parse(JSON.stringify(skillMasters))
        })
        .catch(error => {
          console.log(error)
        })
    }
    fetchSkills() // Fetch skills list

    const domainListTable = ref([])
    const fetchDomains = () => {
      store
        .dispatch('app-domain/fetchAllDomains')
        .then(response => {
          const { domainMasters } = response.data

          domainListTable.value = JSON.parse(JSON.stringify(domainMasters))
        })
        .catch(error => {
          console.log(error)
        })
    }
    fetchDomains() // Fetch domains list

    return {
      projectList,
      developerList,
      roleOptions,
      skillListTable,
      domainListTable,
      menu1,
      menu2,
      resetCareerData,
      cancelDrawer,
      form,
      onSubmit,
      newCareerData,
      valid,
      validate,

      // validation
      validators: { required, emailValidator },
      icons: {
        mdiClose,
        mdiCalendar,
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
