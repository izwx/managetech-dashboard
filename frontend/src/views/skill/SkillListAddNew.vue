<template>
  <v-navigation-drawer
    :value="isAddNewSkillSidebarActive"
    temporary
    touchless
    :right="!$vuetify.rtl"
    :width="$vuetify.breakpoint.smAndUp ? 350 : '100%'"
    app
    @input="val => $emit('update:is-add-new-skill-sidebar-active', val)"
  >
    <v-card height="100%">
      <div class="drawer-header d-flex align-center mb-4">
        <span class="font-weight-semibold text-base text--primary">{{
          isAdd ? $t('Add New Skill') : $t('Edit Skill')
        }}</span>
        <v-spacer></v-spacer>
        <v-btn icon small @click="$emit('update:is-add-new-skill-sidebar-active', false)">
          <v-icon size="22">
            {{ icons.mdiClose }}
          </v-icon>
        </v-btn>
      </div>

      <v-card-text>
        <v-form ref="form" v-model="valid" @submit.prevent="onSubmit">
          <v-row>
            <v-col md="12" cols="12">
              <v-text-field
                v-model="newSkillData.skillName"
                :rules="[validators.required]"
                outlined
                dense
                :label="$t('Skill Name')"
                :placeholder="$t('Skill Name')"
                hide-details="auto"
              ></v-text-field>
            </v-col>
            <v-col cols="12">
              <v-autocomplete
                v-model="newSkillData.projectId"
                :items="projectList"
                item-text="projectName"
                item-value="id"
                outlined
                dense
                :label="$t('Project')"
                :placeholder="$t('Project')"
              ></v-autocomplete>
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
import { mdiClose } from '@mdi/js'
import store from '@/store'
import { onUnmounted, ref, watch } from '@vue/composition-api'
import { required, emailValidator } from '@core/utils/validation'
import skillStoreModule from '@/store/modules/skillStoreModule'
import projectStoreModule from '@/store/modules/projectStoreModule'

export default {
  model: {
    prop: 'isAddNewSkillSidebarActive',
    event: 'update:is-add-new-skill-sidebar-active',
  },
  props: {
    isAddNewSkillSidebarActive: {
      type: Boolean,
      required: true,
    },
    skillData: {
      type: Object,
      default: () => ({}),
    },
    isAdd: {
      type: Boolean,
      required: true,
    },
  },
  setup(props, { emit }) {
    const SKILL_STORE_MODULE_NAME = 'app-skill'
    const PROJECT_STORE_MODULE_NAME = 'app-project'

    // Register module
    if (!store.hasModule(SKILL_STORE_MODULE_NAME)) store.registerModule(SKILL_STORE_MODULE_NAME, skillStoreModule)
    if (!store.hasModule(PROJECT_STORE_MODULE_NAME)) store.registerModule(PROJECT_STORE_MODULE_NAME, projectStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(SKILL_STORE_MODULE_NAME)) store.unregisterModule(SKILL_STORE_MODULE_NAME)
      if (store.hasModule(PROJECT_STORE_MODULE_NAME)) store.unregisterModule(PROJECT_STORE_MODULE_NAME)
    })

    const projectList = ref([])
    const userRole = store.state.sessionManager.user.role
    const userCompanyId = store.state.sessionManager.user.company_id
    store
      .dispatch('app-project/fetchProjects', {
        companyId: (userRole == 'developer' || userRole == 'projectManager') && userCompanyId ? userCompanyId : null,
      })
      .then(response => {
        const { projects } = response.data
        projectList.value = JSON.parse(JSON.stringify(projects))
      })
      .catch(error => {
        console.error(error)
      })

    const blankSkillData = {
      skillName: '',
      projectId: null,
      createrId: store.state.sessionManager.user.id,
    }

    const valid = ref(false)
    const form = ref(null)

    const validate = () => {
      form.value.validate()
    }

    const resetForm = () => {
      form.value.reset()
    }

    const newSkillData = ref(JSON.parse(JSON.stringify(blankSkillData)))

    watch(
      () => props.isAddNewSkillSidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetSkillData()
          if (!props.isAdd) {
            const localSkillData = props.skillData
            localSkillData.projectId = props.skillData.project?.projectId
            newSkillData.value = JSON.parse(JSON.stringify(localSkillData))
          }
        }
      },
    )

    const resetSkillData = () => {
      newSkillData.value = JSON.parse(JSON.stringify(blankSkillData))
      resetForm()
    }

    const cancelDrawer = () => {
      resetSkillData()
      emit('update:is-add-new-skill-sidebar-active', false)
    }

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store.dispatch('app-skill/addSkill', newSkillData.value).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-skill-sidebar-active', false)
          })
        } else {
          store.dispatch('app-skill/updateSkill', [newSkillData.value.id, newSkillData.value]).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-skill-sidebar-active', false)
          })
        }

        resetSkillData()
      } else {
        validate()
      }
    }

    return {
      projectList,
      resetSkillData,
      cancelDrawer,
      form,
      onSubmit,
      newSkillData,
      valid,
      validate,

      // validation
      validators: { required, emailValidator },
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
