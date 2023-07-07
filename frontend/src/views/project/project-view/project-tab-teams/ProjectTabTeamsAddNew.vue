<template>
  <v-navigation-drawer
    :value="isAddNewSidebarActive"
    temporary
    touchless
    :right="!$vuetify.rtl"
    :width="$vuetify.breakpoint.smAndUp ? 350 : '100%'"
    app
    @input="val => $emit('update:is-add-new-sidebar-active', val)"
  >
    <v-card height="100%">
      <div class="drawer-header d-flex align-center mb-4">
        <span class="font-weight-semibold text-base text--primary">{{
          isAdd ? $t('Add New Team') : $t('Edit Team')
        }}</span>
        <v-spacer></v-spacer>
        <v-btn icon small @click="$emit('update:is-add-new-sidebar-active', false)">
          <v-icon size="22">
            {{ icons.mdiClose }}
          </v-icon>
        </v-btn>
      </div>

      <v-card-text v-if="errorMessage">
        <v-alert text type="error" class="mb-0">
          <small class="d-block mb-0">
            {{ $t(errorMessage) }}
          </small>
        </v-alert>
      </v-card-text>

      <v-card-text>
        <v-form ref="form" v-model="valid" @submit.prevent="onSubmit">
          <v-select
            v-model="newProjectTeamData.teamId"
            :rules="[validators.requireSelected]"
            item-text="name"
            item-value="code"
            :items="teamOptions"
            :label="$t('Team')"
            :placeholder="$t('Team')"
            outlined
            dense
            clearable
            hide-details="auto"
            class="mb-6"
            :disabled="!isAdd"
          ></v-select>

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
import router from '@/router'
import { onUnmounted, watch, ref } from '@vue/composition-api'
import { required, integerValidator, requireSelected } from '@core/utils/validation'
import teamStoreModule from '@/store/modules/teamStoreModule'
import projectTeamStoreModule from '@/store/modules/projectTeamStoreModule'

export default {
  model: {
    prop: 'isAddNewSidebarActive',
    event: 'update:is-add-new-sidebar-active',
  },
  props: {
    isAddNewSidebarActive: {
      type: Boolean,
      required: true,
    },
    projectTeamData: {
      type: Object,
      default: () => ({}),
    },
    isAdd: {
      type: Boolean,
      required: true,
    },
  },
  setup(props, { emit }) {
    const TEAM_STORE_MODULE_NAME = 'app-team'
    const PROJECT_TEAM_STORE_MODULE_NAME = 'app-project-team'

    // Register module
    if (!store.hasModule(TEAM_STORE_MODULE_NAME)) store.registerModule(TEAM_STORE_MODULE_NAME, teamStoreModule)
    if (!store.hasModule(PROJECT_TEAM_STORE_MODULE_NAME))
      store.registerModule(PROJECT_TEAM_STORE_MODULE_NAME, projectTeamStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(TEAM_STORE_MODULE_NAME)) store.unregisterModule(TEAM_STORE_MODULE_NAME)
      if (store.hasModule(PROJECT_TEAM_STORE_MODULE_NAME)) store.unregisterModule(PROJECT_TEAM_STORE_MODULE_NAME)
    })

    const teamOptions = ref([])

    /**
     * Fetch teams on page load
     */
    store
      .dispatch('app-team/fetchTeams', {
        options: {
          itemsPerPage: -1,
        },
      })
      .then(response => {
        const { teams } = response.data

        teamOptions.value = teams.map(t => {
          return { code: t.id, name: t.teamName }
        })
      })
      .catch(error => {
        console.log(error)
      })

    const blankProjectTeamData = {
      projectId: parseInt(router.currentRoute.params.id),
      teamId: null,
    }

    const valid = ref(false)
    const form = ref(null)

    const validate = () => {
      form.value.validate()
    }

    const resetForm = () => {
      form.value.reset()
      errorMessage.value = null
    }

    const newProjectTeamData = ref(JSON.parse(JSON.stringify(blankProjectTeamData)))

    watch(
      () => props.isAddNewSidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetTeamData()
          if (!props.isAdd) {
            newProjectTeamData.value = { ...props.projectTeamData }
          }
        }
      },
    )

    const resetTeamData = () => {
      newProjectTeamData.value = JSON.parse(JSON.stringify(blankProjectTeamData))
      resetForm()
    }

    const cancelDrawer = () => {
      resetTeamData()
      emit('update:is-add-new-sidebar-active', false)
    }

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store
            .dispatch('app-project-team/addProjectTeam', newProjectTeamData.value)
            .then(() => {
              emit('refetch-data')
              emit('update:is-add-new-sidebar-active', false)
              resetTeamData()
            })
            .catch(e => {
              // errorMessage.value = e.response.data.errors
              errorMessage.value = 'Registered Team'
            })
        } else {
          store
            .dispatch('app-project-team/updateProjectTeam', [newProjectTeamData.value.id, newProjectTeamData.value])
            .then(() => {
              emit('refetch-data')
              emit('update:is-add-new-sidebar-active', false)
              resetTeamData()
            })
            .catch(e => {
              // errorMessage.value = e.response.data.errors
              errorMessage.value = 'Can not edit the other team in the project'
            })
        }
      } else {
        validate()
      }
    }

    const errorMessage = ref(null)

    return {
      cancelDrawer,
      form,
      onSubmit,
      newProjectTeamData,
      valid,
      validate,

      teamOptions,

      errorMessage,

      // validation
      validators: { required, integerValidator, requireSelected },
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
