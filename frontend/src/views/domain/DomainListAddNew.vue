<template>
  <v-navigation-drawer
    :value="isAddNewDomainSidebarActive"
    temporary
    touchless
    :right="!$vuetify.rtl"
    :width="$vuetify.breakpoint.smAndUp ? 350 : '100%'"
    app
    @input="val => $emit('update:is-add-new-domain-sidebar-active', val)"
  >
    <v-card height="100%">
      <div class="drawer-header d-flex align-center mb-4">
        <span class="font-weight-semibold text-base text--primary">{{
          isAdd ? $t('Add New Domain') : $t('Edit Domain')
        }}</span>
        <v-spacer></v-spacer>
        <v-btn icon small @click="$emit('update:is-add-new-domain-sidebar-active', false)">
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
                v-model="newDomainData.domainName"
                :rules="[validators.required]"
                outlined
                dense
                :label="$t('Domain Name')"
                :placeholder="$t('Domain Name')"
                hide-details="auto"
              ></v-text-field>
            </v-col>
            <v-col cols="12">
              <v-autocomplete
                v-model="newDomainData.projectId"
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
import domainStoreModule from '@/store/modules/domainStoreModule'
import projectStoreModule from '@/store/modules/projectStoreModule'

export default {
  model: {
    prop: 'isAddNewDomainSidebarActive',
    event: 'update:is-add-new-domain-sidebar-active',
  },
  props: {
    isAddNewDomainSidebarActive: {
      type: Boolean,
      required: true,
    },
    domainData: {
      type: Object,
      default: () => ({}),
    },
    isAdd: {
      type: Boolean,
      required: true,
    },
  },
  setup(props, { emit }) {
    const DOMAIN_STORE_MODULE_NAME = 'app-domain'
    const PROJECT_STORE_MODULE_NAME = 'app-project'

    // Register module
    if (!store.hasModule(DOMAIN_STORE_MODULE_NAME)) store.registerModule(DOMAIN_STORE_MODULE_NAME, domainStoreModule)
    if (!store.hasModule(PROJECT_STORE_MODULE_NAME)) store.registerModule(PROJECT_STORE_MODULE_NAME, projectStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(DOMAIN_STORE_MODULE_NAME)) store.unregisterModule(DOMAIN_STORE_MODULE_NAME)
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

    const blankDomainData = {
      domainName: '',
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

    const newDomainData = ref(JSON.parse(JSON.stringify(blankDomainData)))

    watch(
      () => props.isAddNewDomainSidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetDomainData()
          if (!props.isAdd) {
            const localDomainData = props.domainData
            localDomainData.projectId = props.domainData.project.projectId
            newDomainData.value = JSON.parse(JSON.stringify(localDomainData))
          }
        }
      },
    )

    const resetDomainData = () => {
      newDomainData.value = JSON.parse(JSON.stringify(blankDomainData))
      resetForm()
    }

    const cancelDrawer = () => {
      resetDomainData()
      emit('update:is-add-new-domain-sidebar-active', false)
    }

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store.dispatch('app-domain/addDomain', newDomainData.value).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-domain-sidebar-active', false)
          })
        } else {
          store.dispatch('app-domain/updateDomain', [newDomainData.value.id, newDomainData.value]).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-domain-sidebar-active', false)
          })
        }

        resetDomainData()
      } else {
        validate()
      }
    }

    return {
      projectList,
      resetDomainData,
      cancelDrawer,
      form,
      onSubmit,
      newDomainData,
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
