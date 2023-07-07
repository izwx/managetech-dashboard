<template>
  <v-navigation-drawer
    :value="isAddNewToolSidebarActive"
    temporary
    touchless
    :right="!$vuetify.rtl"
    :width="$vuetify.breakpoint.smAndUp ? 350 : '100%'"
    app
    @input="val => $emit('update:is-add-new-tool-sidebar-active', val)"
  >
    <v-card height="100%">
      <div class="drawer-header d-flex align-center mb-4">
        <span class="font-weight-semibold text-base text--primary">{{
          isAdd ? $t('Add New Tool') : $t('Edit Tool')
        }}</span>
        <v-spacer></v-spacer>
        <v-btn icon small @click="$emit('update:is-add-new-tool-sidebar-active', false)">
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
                v-model="newToolData.toolName"
                :rules="[validators.required]"
                outlined
                dense
                :label="$t('Tool Name')"
                :placeholder="$t('Tool Name')"
                hide-details="auto"
              ></v-text-field>
            </v-col>
            <v-col md="12" cols="12">
              <v-text-field
                v-model="newToolData.tokenGuide"
                outlined
                dense
                :label="$t('Token Guide')"
                :placeholder="$t('Token Guide')"
                hide-details="auto"
              ></v-text-field>
              <span class="text-caption">APIアクセス用のTokenやパスワードを想定</span>
            </v-col>
            <v-col md="12" cols="12">
              <v-text-field
                v-model="newToolData.targetGuide"
                outlined
                dense
                :label="$t('Target Guide')"
                :placeholder="$t('Target Guide')"
                hide-details="auto"
              ></v-text-field>
              <span class="text-caption">SlackのチャネルやJiraのプロジェクト、Gitのリポジトリ名などを想定</span>
            </v-col>
            <v-col md="12" cols="12">
              <v-text-field
                v-model="newToolData.payloadGuide"
                outlined
                dense
                :label="$t('Payload Guide')"
                :placeholder="$t('Payload Guide')"
                hide-details="auto"
              ></v-text-field>
              <span class="text-caption">その他のデータ</span>
            </v-col>
            <v-col md="12" cols="12">
              <v-text-field
                v-model="newToolData.accountNameGuide"
                outlined
                dense
                :label="$t('Account Name Guide')"
                :placeholder="$t('Account Name Guide')"
                hide-details="auto"
              ></v-text-field>
              <span class="text-caption">ツールのアカウント名を想定</span>
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
import toolStoreModule from '@/store/modules/toolStoreModule'

export default {
  model: {
    prop: 'isAddNewToolSidebarActive',
    event: 'update:is-add-new-tool-sidebar-active',
  },
  props: {
    isAddNewToolSidebarActive: {
      type: Boolean,
      required: true,
    },
    toolData: {
      type: Object,
      default: () => ({}),
    },
    isAdd: {
      type: Boolean,
      required: true,
    },
  },
  setup(props, { emit }) {
    const TOOL_STORE_MODULE_NAME = 'app-tool'

    // Register module
    if (!store.hasModule(TOOL_STORE_MODULE_NAME)) store.registerModule(TOOL_STORE_MODULE_NAME, toolStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(TOOL_STORE_MODULE_NAME)) store.unregisterModule(TOOL_STORE_MODULE_NAME)
    })

    const blankToolData = {
      toolName: '',
      tokenGuide: '',
      targetGuide: '',
      payloadGuide: '',
      accountNameGuide: '',
    }

    const valid = ref(false)
    const form = ref(null)

    const validate = () => {
      form.value.validate()
    }

    const resetForm = () => {
      form.value.reset()
    }

    const newToolData = ref(JSON.parse(JSON.stringify(blankToolData)))

    watch(
      () => props.isAddNewToolSidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetToolData()
          if (!props.isAdd) {
            newToolData.value = JSON.parse(JSON.stringify(props.toolData))
          }
        }
      },
    )

    const resetToolData = () => {
      newToolData.value = JSON.parse(JSON.stringify(blankToolData))
      resetForm()
    }

    const cancelDrawer = () => {
      resetToolData()
      emit('update:is-add-new-tool-sidebar-active', false)
    }

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store.dispatch('app-tool/addTool', newToolData.value).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-tool-sidebar-active', false)
          })
        } else {
          store.dispatch('app-tool/updateTool', [newToolData.value.id, newToolData.value]).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-tool-sidebar-active', false)
          })
        }

        resetToolData()
      } else {
        validate()
      }
    }

    return {
      resetToolData,
      cancelDrawer,
      form,
      onSubmit,
      newToolData,
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
