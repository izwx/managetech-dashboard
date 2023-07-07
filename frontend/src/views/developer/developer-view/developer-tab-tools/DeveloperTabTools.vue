<template>
  <v-card class="developer-tab-notification">
    <v-card-title>
      <span>{{ $t("Tool's Account Name") }}</span>
    </v-card-title>

    <!-- Developer Tool Form -->
    <v-card-text>
      <v-form @submit.prevent="onSubmit">
        <v-row v-for="(devTool, index) in newDeveloperTools" :key="index">
          <v-col cols="12" md="2">
            <label :for="devTool.toolName">{{ devTool.toolName }}</label>
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field
              :id="devTool.toolName"
              v-model="devTool.accountName"
              :placeholder="`${devTool.toolName} account name`"
              :hint="devTool.accountNameGuide"
              persistent-hint
              autocomplete="off"
              outlined
              dense
            ></v-text-field>
          </v-col>
        </v-row>
        <v-col md="12" cols="12">
          <v-btn color="primary" class="me-3" type="submit">
            {{ $t('Update') }}
          </v-btn>
          <v-btn color="secondary" outlined type="reset">
            {{ $t('Discard') }}
          </v-btn>
        </v-col>

        <v-alert color="info" dark dense prominent :value="alert">
          {{ $t('Updated') }}
        </v-alert>
      </v-form>
    </v-card-text>
  </v-card>
</template>

<script>
import store from '@/store'
import { ref, onUnmounted, watch } from '@vue/composition-api'
import developerStoreModule from '@/store/modules/developerStoreModule'
import toolStoreModule from '@/store/modules/toolStoreModule'

export default {
  props: {
    developerData: {
      type: Object,
      required: true,
    },
  },
  setup(props) {
    const DEVELOPER_STORE_MODULE_NAME = 'app-developer'
    const TOOL_STORE_MODULE_NAME = 'app-tool'

    // Register module
    if (!store.hasModule(DEVELOPER_STORE_MODULE_NAME))
      store.registerModule(DEVELOPER_STORE_MODULE_NAME, developerStoreModule)
    if (!store.hasModule(TOOL_STORE_MODULE_NAME)) store.registerModule(TOOL_STORE_MODULE_NAME, toolStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(DEVELOPER_STORE_MODULE_NAME)) store.unregisterModule(DEVELOPER_STORE_MODULE_NAME)
      if (store.hasModule(TOOL_STORE_MODULE_NAME)) store.unregisterModule(TOOL_STORE_MODULE_NAME)
    })

    const { developerToolMaps } = props.developerData

    const newDeveloperTools = ref(JSON.parse(JSON.stringify(developerToolMaps)))

    const alert = ref(false)

    store
      .dispatch('app-tool/fetchTools')
      .then(res => {
        const { toolMasters } = res.data
        const developerToolIds = developerToolMaps.map(t => t.toolId)
        // unless tool id is included in developer tools, add developertool value to the new developer tools
        toolMasters.map(tool => {
          if (!developerToolIds.includes(tool.id)) {
            newDeveloperTools.value = [
              ...newDeveloperTools.value,
              {
                tool_id: tool.id,
                toolName: tool.toolName,
                developer_id: props.developerData.id,
                accountName: '',
                accountNameGuide: tool.accountNameGuide,
              },
            ]
          }
        })
      })
      .catch(error => {
        console.log(error)
      })

    const onSubmit = () => {
      store
        .dispatch('app-developer/updateDeveloper', [
          props.developerData.id,
          {
            developerToolMapsAttributes: newDeveloperTools.value,
          },
        ])
        .then(res => {
          alert.value = true
        })
        .catch(error => {
          console.error(error)
        })
    }

    watch(alert, (val, OldVal) => {
      if (val) {
        setTimeout(() => {
          alert.value = false
        }, 5000)
      }
    })

    return {
      newDeveloperTools,
      onSubmit,
      alert,
    }
  },
}
</script>
