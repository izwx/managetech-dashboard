<template>
  <v-navigation-drawer
    :value="isAddNewCompanySidebarActive"
    temporary
    touchless
    :right="!$vuetify.rtl"
    :width="$vuetify.breakpoint.smAndUp ? 350 : '100%'"
    app
    @input="val => $emit('update:is-add-new-company-sidebar-active', val)"
  >
    <v-card height="100%">
      <div class="drawer-header d-flex align-center mb-4">
        <span class="font-weight-semibold text-base text--primary">{{
          isAdd ? $t('Add New Company') : $t('Edit Company')
        }}</span>
        <v-spacer></v-spacer>
        <v-btn icon small @click="$emit('update:is-add-new-company-sidebar-active', false)">
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
                v-model="newCompanyData.companyName"
                :rules="[validators.required]"
                outlined
                dense
                :label="$t('Company Name')"
                :placeholder="$t('Company Name')"
                hide-details="auto"
              ></v-text-field>
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
import companyStoreModule from '@/store/modules/companyStoreModule'

export default {
  model: {
    prop: 'isAddNewCompanySidebarActive',
    event: 'update:is-add-new-company-sidebar-active',
  },
  props: {
    isAddNewCompanySidebarActive: {
      type: Boolean,
      required: true,
    },
    companyData: {
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

    const blankCompanyData = {
      companyName: '',
    }

    const valid = ref(false)
    const form = ref(null)

    const validate = () => {
      form.value.validate()
    }

    const resetForm = () => {
      form.value.reset()
    }

    const newCompanyData = ref(JSON.parse(JSON.stringify(blankCompanyData)))

    watch(
      () => props.isAddNewCompanySidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetCompanyData()
          if (!props.isAdd) {
            newCompanyData.value = JSON.parse(JSON.stringify(props.companyData))
          }
        }
      },
    )

    const resetCompanyData = () => {
      newCompanyData.value = JSON.parse(JSON.stringify(blankCompanyData))
      resetForm()
    }

    const cancelDrawer = () => {
      resetCompanyData()
      emit('update:is-add-new-company-sidebar-active', false)
    }

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store.dispatch('app-company/addCompany', newCompanyData.value).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-company-sidebar-active', false)
          })
        } else {
          store.dispatch('app-company/updateCompany', [newCompanyData.value.id, newCompanyData.value]).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-company-sidebar-active', false)
          })
        }

        resetCompanyData()
      } else {
        validate()
      }
    }

    return {
      resetCompanyData,
      cancelDrawer,
      form,
      onSubmit,
      newCompanyData,
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
