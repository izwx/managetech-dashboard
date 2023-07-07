<template>
  <v-navigation-drawer
    :value="isAddNewDeveloperSidebarActive"
    temporary
    touchless
    :right="!$vuetify.rtl"
    :width="$vuetify.breakpoint.smAndUp ? 350 : '100%'"
    app
    @input="val => $emit('update:is-add-new-developer-sidebar-active', val)"
  >
    <v-card height="100%">
      <div class="drawer-header d-flex align-center mb-4">
        <span class="font-weight-semibold text-base text--primary">{{
          isAdd ? $t('Add New Developer') : $t('Edit Developer')
        }}</span>
        <v-spacer></v-spacer>
        <v-btn icon small @click="$emit('update:is-add-new-developer-sidebar-active', false)">
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
          <v-row>
            <v-col md="12" cols="12">
              <v-select
                v-model="newDeveloperData.userId"
                item-text="name"
                item-value="id"
                :items="duserListTable"
                :label="$t('User')"
                :placeholder="$t('User')"
                outlined
                dense
                clearable
                hide-details
                :disabled="!isAdd"
              ></v-select>
            </v-col>
            <v-col md="12" cols="12">
              <v-select
                v-model="newDeveloperData.teamIds"
                item-text="teamName"
                item-value="id"
                :items="teamListTable"
                :label="$t('Team Name')"
                :placeholder="$t('Team Name')"
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
import { mdiClose } from '@mdi/js'
import countries from '@/@fake-db/data/other/countries'
import store from '@/store'
import axios from '@axios'
import { onUnmounted, ref, watch } from '@vue/composition-api'
import { required, emailValidator } from '@core/utils/validation'
import useTeamsList from '@/views/team/team-list/useTeamsList'
import teamStoreModule from '@/store/modules/teamStoreModule'
import companyStoreModule from '@/store/modules/companyStoreModule'
import useDevelopersList from './useDevelopersList'

export default {
  model: {
    prop: 'isAddNewDeveloperSidebarActive',
    event: 'update:is-add-new-developer-sidebar-active',
  },
  props: {
    isAddNewDeveloperSidebarActive: {
      type: Boolean,
      required: true,
    },
    developerData: {
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
    const COMPANY_STORE_MODULE_NAME = 'app-company'

    // Register module
    if (!store.hasModule(TEAM_STORE_MODULE_NAME)) store.registerModule(TEAM_STORE_MODULE_NAME, teamStoreModule)
    if (!store.hasModule(COMPANY_STORE_MODULE_NAME)) store.registerModule(COMPANY_STORE_MODULE_NAME, companyStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(TEAM_STORE_MODULE_NAME)) store.unregisterModule(TEAM_STORE_MODULE_NAME)
      if (store.hasModule(COMPANY_STORE_MODULE_NAME)) store.unregisterModule(COMPANY_STORE_MODULE_NAME)
    })

    const { teamListTable, fetchTeams } = useTeamsList()

    const duserListTable = ref([])

    const { userCompanyId } = useDevelopersList()

    // fetch data
    const fetchUsers = () => {
      axios
        .get('/dev_users', { params: { companyId: userCompanyId } })
        .then(response => {
          const { users } = response.data
          duserListTable.value = [...users]
        })
        .catch(error => {
          console.error(error)
        })
    }

    //fetch team list on page load
    fetchTeams()
    //fetch companies list on page load
    fetchUsers()

    const blankDeveloperData = {
      teamIds: [],
      userId: null,
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

    const newDeveloperData = ref(JSON.parse(JSON.stringify(blankDeveloperData)))

    watch(
      () => props.isAddNewDeveloperSidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetDeveloperData()
          if (!props.isAdd) {
            props.developerData.teamIds = JSON.parse(JSON.stringify(props.developerData.teams.map(t => t.id)))
            newDeveloperData.value = JSON.parse(JSON.stringify(props.developerData))
          }
        }
      },
    )

    const resetDeveloperData = () => {
      newDeveloperData.value = JSON.parse(JSON.stringify(blankDeveloperData))
      resetForm()
    }

    const cancelDrawer = () => {
      resetDeveloperData()
      emit('update:is-add-new-developer-sidebar-active', false)
    }

    const errorMessage = ref(null)

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store
            .dispatch('app-developer/addDeveloper', [newDeveloperData.value, userCompanyId])
            .then(() => {
              emit('refetch-data')
              emit('update:is-add-new-developer-sidebar-active', false)
            })
            .catch(err => {
              errorMessage.value = err.response.data.errors
            })
        } else {
          store
            .dispatch('app-developer/updateDeveloper', [newDeveloperData.value.id, newDeveloperData.value])
            .then(() => {
              emit('refetch-data')
              emit('update:is-add-new-developer-sidebar-active', false)
            })
        }

        resetDeveloperData()
      } else {
        validate()
      }
    }

    return {
      teamListTable,
      duserListTable,
      fetchTeams,
      resetDeveloperData,
      cancelDrawer,
      form,
      onSubmit,
      countries,
      newDeveloperData,
      valid,
      validate,
      errorMessage,

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
