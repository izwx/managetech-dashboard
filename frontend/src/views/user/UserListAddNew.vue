<template>
  <v-navigation-drawer
    :value="isAddNewUserSidebarActive"
    temporary
    touchless
    :right="!$vuetify.rtl"
    :width="$vuetify.breakpoint.smAndUp ? 350 : '100%'"
    app
    @input="val => $emit('update:is-add-new-user-sidebar-active', val)"
  >
    <v-card height="100%">
      <div class="drawer-header d-flex align-center mb-4">
        <span class="font-weight-semibold text-base text--primary">{{ $t('Add New User') }}</span>
        <v-spacer></v-spacer>
        <v-btn icon small @click="$emit('update:is-add-new-user-sidebar-active', false)">
          <v-icon size="22">
            {{ icons.mdiClose }}
          </v-icon>
        </v-btn>
      </div>

      <v-card-text>
        <v-form ref="form" v-model="valid" @submit.prevent="onSubmit">
          <v-text-field
            v-model="newUserData.email"
            :rules="[validators.required, validators.emailValidator]"
            outlined
            dense
            type="email"
            :label="$t('Email')"
            :placeholder="$t('Email')"
            hide-details="auto"
            class="mb-6"
          ></v-text-field>

          <v-text-field
            v-model="newUserData.name"
            :rules="[validators.required]"
            outlined
            dense
            type="text"
            :label="$t('Name')"
            :placeholder="$t('Name')"
            hide-details="auto"
            class="mb-6"
          ></v-text-field>

          <v-text-field
            v-model="newUserData.password"
            :type="isPasswordVisible ? 'text' : 'password'"
            :label="$t('Password')"
            :placeholder="$t('Password')"
            :append-icon="isPasswordVisible ? icons.mdiEyeOffOutline : icons.mdiEyeOutline"
            :rules="[...(isAdd ? [validators.required] : [])]"
            hide-details="auto"
            class="mb-6"
            outlined
            dense
            @click:append="isPasswordVisible = !isPasswordVisible"
          ></v-text-field>

          <v-select
            v-model="newUserData.companyId"
            :rules="[validators.requireSelected]"
            :items="companyOptions"
            item-text="name"
            item-value="code"
            :label="$t('Company')"
            :placeholder="$t('Company')"
            outlined
            dense
            clearable
            hide-details="auto"
            class="mb-6"
          ></v-select>

          <v-select
            v-model="newUserData.role"
            :rules="[validators.requireSelected]"
            :label="$t('Role')"
            :placeholder="$t('Role')"
            :items="roleOptions"
            item-text="title"
            item-value="value"
            outlined
            dense
            hide-details="auto"
            class="mb-6"
          >
            <template v-slot:item="{ item }">
              <span>{{ $t(item.title) }}</span>
            </template>
            <template v-slot:selection="{ item }">
              <span>{{ $t(item.title) }}</span>
            </template>
          </v-select>

          <v-btn color="primary" class="me-3" type="submit">
            {{ $t('Add') }}
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
import { mdiClose, mdiEyeOutline, mdiEyeOffOutline } from '@mdi/js'
import store from '@/store'
import { onUnmounted, ref, watch } from '@vue/composition-api'
import { required, emailValidator, requireSelected } from '@core/utils/validation'
import companyStoreModule from '@/store/modules/companyStoreModule'

export default {
  model: {
    prop: 'isAddNewUserSidebarActive',
    event: 'update:is-add-new-user-sidebar-active',
  },
  props: {
    isAddNewUserSidebarActive: {
      type: Boolean,
      required: true,
    },
    roleOptions: {
      type: Array,
      required: true,
    },
    userData: {
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

    const isPasswordVisible = ref(false)

    const blankUserData = {
      name: '',
      email: '',
      password: '',
      role: null,
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

    const newUserData = ref(JSON.parse(JSON.stringify(blankUserData)))

    watch(
      () => props.isAddNewUserSidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetUserData()
          if (!props.isAdd) {
            newUserData.value = JSON.parse(JSON.stringify(props.userData))
          }
        }
      },
    )

    const resetUserData = () => {
      newUserData.value = JSON.parse(JSON.stringify(blankUserData))
      resetForm()
    }

    const cancelDrawer = () => {
      resetUserData()
      emit('update:is-add-new-user-sidebar-active', false)
    }

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store
            .dispatch('app-user/addUser', newUserData.value)
            .then(() => {
              emit('refetch-data')
            })
            .finally(() => {
              emit('update:is-add-new-user-sidebar-active', false)
            })
        } else {
          store
            .dispatch('app-user/updateUser', [newUserData.value.id, newUserData.value])
            .then(() => {
              emit('refetch-data')
            })
            .finally(() => {
              emit('update:is-add-new-user-sidebar-active', false)
            })
        }

        resetUserData()
      } else {
        validate()
      }
    }

    return {
      resetUserData,
      form,
      onSubmit,
      cancelDrawer,
      newUserData,
      companyOptions,
      isPasswordVisible,
      valid,
      validate,

      // validation
      validators: { required, emailValidator, requireSelected },
      icons: {
        mdiClose,
        mdiEyeOutline,
        mdiEyeOffOutline,
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
