<template>
  <v-navigation-drawer
    :value="isAddNewTeamSidebarActive"
    temporary
    touchless
    :right="!$vuetify.rtl"
    :width="$vuetify.breakpoint.smAndUp ? 350 : '100%'"
    app
    @input="val => $emit('update:is-add-new-team-sidebar-active', val)"
  >
    <v-card height="100%">
      <div class="drawer-header d-flex align-center mb-4">
        <span class="font-weight-semibold text-base text--primary">{{
          isAdd ? $t('Add New Team') : $t('Edit Team')
        }}</span>
        <v-spacer></v-spacer>
        <v-btn icon small @click="$emit('update:is-add-new-team-sidebar-active', false)">
          <v-icon size="22">
            {{ icons.mdiClose }}
          </v-icon>
        </v-btn>
      </div>

      <v-card-text>
        <v-form ref="form" v-model="valid" @submit.prevent="onSubmit">
          <v-text-field
            v-model="newTeamData.teamName"
            :rules="[validators.required]"
            outlined
            dense
            :label="$t('Team Name')"
            :placeholder="$t('Team Name')"
            hide-details="auto"
            class="mb-6"
          ></v-text-field>

          <v-select
            v-model="newTeamData.companyId"
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
import countries from '@/@fake-db/data/other/countries'
import store from '@/store'
import { onUnmounted, watch, ref } from '@vue/composition-api'
import { required, emailValidator, requireSelected } from '@core/utils/validation'
import companyStoreModule from '@/store/modules/companyStoreModule'

export default {
  model: {
    prop: 'isAddNewTeamSidebarActive',
    event: 'update:is-add-new-team-sidebar-active',
  },
  props: {
    isAddNewTeamSidebarActive: {
      type: Boolean,
      required: true,
    },
    teamData: {
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
    // Register module
    if (!store.hasModule(COMPANY_STORE_MODULE_NAME)) store.registerModule(COMPANY_STORE_MODULE_NAME, companyStoreModule)
    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(COMPANY_STORE_MODULE_NAME)) store.unregisterModule(COMPANY_STORE_MODULE_NAME)
    })

    const blankTeamData = {
      teamName: '',
      companyId: null,
    }

    const valid = ref(false)
    const form = ref(null)

    const validate = () => {
      form.value.validate()
    }

    const resetForm = () => {
      form.value.reset()
    }

    const newTeamData = ref(JSON.parse(JSON.stringify(blankTeamData)))

    watch(
      () => props.isAddNewTeamSidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetTeamData()
          if (!props.isAdd) {
            newTeamData.value = JSON.parse(JSON.stringify(props.teamData))
          }
        }
      },
    )

    const companyOptions = ref([])
    // fetch comapnies
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

    const resetTeamData = () => {
      newTeamData.value = JSON.parse(JSON.stringify(blankTeamData))
      resetForm()
    }

    const cancelDrawer = () => {
      resetTeamData()
      emit('update:is-add-new-team-sidebar-active', false)
    }

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store.dispatch('app-team/addTeam', newTeamData.value).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-team-sidebar-active', false)
          })
        } else {
          store.dispatch('app-team/updateTeam', [newTeamData.value.id, newTeamData.value]).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-team-sidebar-active', false)
          })
        }

        resetTeamData()
      } else {
        validate()
      }
    }

    return {
      companyOptions,
      resetTeamData,
      cancelDrawer,
      form,
      onSubmit,
      countries,
      newTeamData,
      valid,
      validate,

      // validation
      validators: { required, emailValidator, requireSelected },
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
