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
          isAdd ? $t('Add New Tool') : $t('Edit Tool')
        }}</span>
        <v-spacer></v-spacer>
        <v-btn icon small @click="$emit('update:is-add-new-sidebar-active', false)">
          <v-icon size="22">
            {{ icons.mdiClose }}
          </v-icon>
        </v-btn>
      </div>

      <v-card-text>
        <v-form ref="form" v-model="valid" @submit.prevent="onSubmit">
          <v-select
            v-model="newProjectToolData.toolId"
            :rules="[validators.requireSelected]"
            item-text="name"
            item-value="code"
            :items="toolOptions"
            :label="$t('Tools')"
            :placeholder="$t('Tools')"
            outlined
            dense
            clearable
            hide-details="auto"
            class="mb-6"
            v-on:change="changeTool"
          ></v-select>

          <v-text-field
            v-model="newProjectToolData.token"
            outlined
            dense
            :label="$t('Token')"
            :placeholder="$t('Token')"
            hide-details="auto"
            class="mb-6"
            :hint="selectedTool.tokenGuide"
            persistent-hint
          ></v-text-field>

          <v-text-field
            v-model="newProjectToolData.target"
            outlined
            dense
            :label="$t('Target')"
            :placeholder="$t('Target')"
            hide-details="auto"
            class="mb-6"
            :hint="selectedTool.targetGuide"
            persistent-hint
          ></v-text-field>

          <v-text-field
            v-model="newProjectToolData.payload"
            outlined
            dense
            :label="$t('Payload')"
            :placeholder="$t('Payload')"
            hide-details="auto"
            class="mb-6"
            :hint="selectedTool.payloadGuide"
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
import toolStoreModule from '@/store/modules/toolStoreModule'
import projectToolStoreModule from '@/store/modules/projectToolStoreModule'

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
    projectToolList: {
      type: Array,
      default: () => [],
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
    const PROJECT_TOOL_STORE_MODULE_NAME = 'app-project-tool'

    // Register module
    if (!store.hasModule(TOOL_STORE_MODULE_NAME)) store.registerModule(TOOL_STORE_MODULE_NAME, toolStoreModule)
    if (!store.hasModule(PROJECT_TOOL_STORE_MODULE_NAME))
      store.registerModule(PROJECT_TOOL_STORE_MODULE_NAME, projectToolStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(TOOL_STORE_MODULE_NAME)) store.unregisterModule(TOOL_STORE_MODULE_NAME)
      if (store.hasModule(PROJECT_TOOL_STORE_MODULE_NAME)) store.unregisterModule(PROJECT_TOOL_STORE_MODULE_NAME)
    })

    const allToolMasters = ref([])
    const selectedTool = ref({})
    const fullToolOptions = ref([])
    const toolOptions = ref([])

    // fetch data
    const fetchTools = () => {
      store
        .dispatch('app-tool/fetchTools', {})
        .then(response => {
          const { toolMasters } = response.data

          allToolMasters.value = JSON.parse(JSON.stringify(toolMasters))

          toolOptions.value = toolMasters.map(tool => {
            return { code: tool.id, name: tool.toolName }
          })

          fullToolOptions.value = toolOptions.value
        })
        .catch(error => {
          console.log(error)
        })
    }
    //fetch companies list on page load
    fetchTools()

    const blankProjectToolData = {
      projectId: parseInt(router.currentRoute.params.id),
      toolId: null,
      token: '',
      target: '',
      payload: '',
    }

    const valid = ref(false)
    const form = ref(null)

    const validate = () => {
      form.value.validate()
    }

    const resetForm = () => {
      form.value.reset()
    }

    const newProjectToolData = ref(JSON.parse(JSON.stringify(blankProjectToolData)))

    watch(
      () => props.isAddNewSidebarActive,
      (oldStatus, newStatus) => {
        if (oldStatus) {
          resetProjectToolData()
          let existedToolIds = props.projectToolList.map(({ toolId }) => toolId)
          if (!props.isAdd) {
            newProjectToolData.value = { ...props.toolData }
            //If edit, remove the current selected id from existed tools, because current tool id has already being used in the tools list
            var index = existedToolIds.indexOf(props.toolData.toolId)
            if (index !== -1) {
              existedToolIds.splice(index, 1)
            }
            selectedTool.value = allToolMasters.value.find(tool => tool.id == props.toolData.toolId)
          }
          toolOptions.value = fullToolOptions.value.filter(op => !existedToolIds.includes(op.code))
        }
      },
    )

    const resetProjectToolData = () => {
      newProjectToolData.value = JSON.parse(JSON.stringify(blankProjectToolData))
      selectedTool.value = JSON.parse(JSON.stringify({}))
      resetForm()
    }

    const cancelDrawer = () => {
      resetProjectToolData()
      emit('update:is-add-new-sidebar-active', false)
    }

    const changeTool = value => {
      selectedTool.value = allToolMasters.value.find(tool => tool.id == value, {})
    }

    const onSubmit = () => {
      if (valid.value) {
        if (props.isAdd) {
          store.dispatch('app-project-tool/addProjectTool', newProjectToolData.value).then(() => {
            emit('refetch-data')
            emit('update:is-add-new-sidebar-active', false)
          })
        } else {
          store
            .dispatch('app-project-tool/updateProjectTool', [newProjectToolData.value.id, newProjectToolData.value])
            .then(() => {
              emit('refetch-data')
              emit('update:is-add-new-sidebar-active', false)
            })
        }

        resetProjectToolData()
      } else {
        validate()
      }
    }

    return {
      resetProjectToolData,
      cancelDrawer,
      form,
      onSubmit,
      newProjectToolData,
      valid,
      validate,

      changeTool,
      toolOptions,
      selectedTool,

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
