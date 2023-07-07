<template>
  <v-card>
    <v-card-title class="align-start">
      <span class="text-xl font-weight-semibold primary--text mb-2">
        {{ projectData.projectName }}
      </span>
      <v-spacer></v-spacer>
      <v-btn icon small class="me-n3 mt-n2">
        <v-icon>
          {{ icons.mdiDotsVertical }}
        </v-icon>
      </v-btn>
    </v-card-title>

    <v-card-subtitle class="mb-8 mt-n5">
      <span class="font-weight-semibold text--primary me-1">Total 48.5% Growth</span>
      <span>😎 this month</span>
    </v-card-subtitle>

    <v-card-text>
      <v-row>
        <v-col v-for="data in statisticsData" :key="data.title" cols="6" md="2" class="d-flex align-center">
          <v-avatar size="44" :color="data.color" rounded class="elevation-1">
            <v-icon dark color="white" size="30">
              {{ data.icon }}
            </v-icon>
          </v-avatar>
          <div class="ms-3">
            <p class="text-xs mb-0">
              {{ data.title }}
            </p>
            <h3 class="text-xl font-weight-semibold">
              {{ data.total }}
            </h3>
          </div>
        </v-col>
      </v-row>
    </v-card-text>
  </v-card>
</template>

<script>
// eslint-disable-next-line object-curly-newline
import {
  mdiAccountOutline,
  mdiCurrencyUsd,
  mdiTrendingUp,
  mdiDotsVertical,
  mdiLabelOutline,
  mdiFileDocumentOutline,
  mdiMessageReplyTextOutline,
  mdiBookClockOutline,
} from '@mdi/js'
import { watch, ref } from '@vue/composition-api'

export default {
  props: {
    projectData: {
      type: Object,
      required: true,
    },
  },
  setup(props, { emit }) {
    const projectDataLocal = ref({})
    projectDataLocal.value = JSON.parse(JSON.stringify(props.projectData))

    const statisticsData = [
      {
        title: 'チーム人数',
        icon: mdiAccountOutline,
        color: 'primary',
        total: 12,
      },
      {
        title: '平均ベロシティ',
        icon: mdiTrendingUp,
        color: 'success',
        total: 5.8,
      },
      {
        title: '平均稼働率',
        icon: mdiLabelOutline,
        color: 'warning',
        total: 7.6,
      },
      {
        title: 'ドキュメント数',
        icon: mdiFileDocumentOutline,
        color: 'info',
        total: 16,
      },
      {
        title: '平均メッセージ数',
        icon: mdiMessageReplyTextOutline,
        color: 'secondary',
        total: '88',
      },
      {
        title: '平均リードタイム',
        icon: mdiBookClockOutline,
        color: 'error',
        total: '65',
      },
    ]

    watch(
      () => props.projectData,
      () => {
        projectDataLocal.value = JSON.parse(JSON.stringify(props.projectData))
      },
    )

    return {
      projectDataLocal,
      statisticsData,

      // icons
      icons: {
        mdiDotsVertical,
        mdiTrendingUp,
        mdiAccountOutline,
        mdiLabelOutline,
        mdiCurrencyUsd,
      },
    }
  },
}
</script>
