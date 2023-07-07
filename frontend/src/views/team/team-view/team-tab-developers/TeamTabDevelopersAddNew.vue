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
          isAdd ? $t('Add New Developer') : $t('Edit Developer')
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
            v-model="newDeveloperTeamData.developerId"
            :rules="[validators.requireSelected]"
            item-text="name"
            item-value="code"
            :items="developerOptions"
            :label="$t('Developer')"
            :placeholder="$t('Developer')"
            outlined
            dense
            clearable
            hide-details="auto"
            class="mb-6"
            :disabled="!isAdd"
          ></v-select>

          <v-text-field
            v-model="newDeveloperTeamData.workHour"
            outlined
            dense
            :label="$t('Work Hours')"
            :placeholder="$t('Work Hours')"
            hide-details="auto"
            class="mb-6"
            persistent-hint
          ></v-text-field>

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
import developerStoreModule from '@/store/modules/developerStoreModule'
import developerTeamStoreModule from '@/store/modules/developerTeamStoreModule'

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
    developerTeamData: {
      type: Object,
      default: () => ({}),
    },
    isAdd: {
      type: Boolean,
      required: true,
    },
  },
  setup(props, { emit }) {
    const DEVELOPER_STORE_MODULE_NAME = 'app-developer'
    const DEVELOPER_TEAM_STORE_MODULE_NAME = 'app-developer-team'

    // Register module
    if (!store.hasModule(DEVELOPER_STORE_MODULE_NAME))
      store.registerModule(DEVELOPER_STORE_MODULE_NAME, developerStoreModule)
    if (!store.hasModule(DEVELOPER_TEAM_STORE_MODULE_NAME))
      store.registerModule(DEVELOPER_TEAM_STORE_MODULE_NAME, developerTeamStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(DEVELOPER_STORE_MODULE_NAME)) store.unregisterModule(DEVELOPER_STORE_MODULE_NAME)
      if (store.hasModule(DEVELOPER_TEAM_STORE_MODULE_NAME)) store.unregisterModule(DEVELOPER_TEAM_STORE_MODULE_NAME)
    })

    const developerOptions = ref([])

    /**
     * Fetch developers on page load
     */
    store
      .dispatch('app-developer/fetchDevelopers', {
        options: {
          itemsPerPage: -1,
        },
      })
      .then(response => {
        const { developers } = response.data

        developerOptions.value = developers.map(dev => {
          return { code: dev.id, name: dev.developerName }
        })
      })
      .catch(error => {
        console.log(error)
      })

    const blankDeveloperTeamData = {
      teamId: parseInt(router.currentRoute.params.id),
      developerId: null,
      workHour: '',
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

    const newDeveloperTeamData = ref(JSON.parse(JSON.stringify(blankDeveloperTeamData)))

    watch(
      () => props.isAddNewSidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetDeveloperData()
          if (!props.isAdd) {
            newDeveloperTeamData.value = { ...props.developerTeamData }
          }
        }
      },
    )

    const resetDeveloperData = () => {
      newDeveloperTeamData.value = JSON.parse(JSON.stringify(blankDeveloperTeamData))
      resetForm()
    }

    const cancelDrawer = () => {
      resetDeveloperData()
      emit('update:is-add-new-sidebar-active', false)
    }

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store
            .dispatch('app-developer-team/addDeveloperTeam', newDeveloperTeamData.value)
            .then(() => {
              emit('refetch-data')
              emit('update:is-add-new-sidebar-active', false)
              resetDeveloperData()
            })
            .catch(e => {
              // errorMessage.value = e.response.data.errors
              errorMessage.value = 'Registered developer'
            })
        } else {
          store
            .dispatch('app-developer-team/updateDeveloperTeam', [
              newDeveloperTeamData.value.id,
              newDeveloperTeamData.value,
            ])
            .then(() => {
              emit('refetch-data')
              emit('update:is-add-new-sidebar-active', false)
              resetDeveloperData()
            })
            .catch(e => {
              // errorMessage.value = e.response.data.errors
              errorMessage.value = 'Can not edit the other developer in the team'
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
      newDeveloperTeamData,
      valid,
      validate,

      developerOptions,

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
