<template>
  <v-card>
    <v-card-title class="align-start">
      <span class="text-xl font-weight-semibold primary--text mb-2">
        {{ teamData.teamName }}
      </span>
      <v-spacer></v-spacer>
    </v-card-title>

    <v-card-subtitle class="mb-8 mt-n5">
      <span class="font-weight-semibold text--primary me-1">Total 48.5% Growth</span>
      <span>😎 this month</span>
    </v-card-subtitle>

    <v-card-text>
      <v-row>
        <!-- チーム人数 -->
        <v-col cols="6" md="2" class="d-flex align-center">
          <v-avatar size="44" color="primary" rounded class="elevation-1">
            <v-icon dark color="white" size="30">
              {{ icons.mdiAccountOutline }}
            </v-icon>
          </v-avatar>
          <div class="ms-3">
            <p class="text-xs mb-0">{{ $t('Members Count') }}</p>
            <h3 class="text-xl font-weight-semibold">
              {{ teamData.numMembers }}
            </h3>
          </div>
        </v-col>

        <!-- 平均ベロシティ -->
        <v-col cols="6" md="2" class="d-flex align-center">
          <v-avatar size="44" color="success" rounded class="elevation-1">
            <v-icon dark color="white" size="30">
              {{ icons.mdiTrendingUp }}
            </v-icon>
          </v-avatar>
          <div class="ms-3">
            <p class="text-xs mb-0">{{ $t('Average Velocity') }}</p>
            <h3 class="text-xl font-weight-semibold">
              {{ parseFloat(teamData.avgVelocity).toFixed(2) }}
            </h3>
          </div>
        </v-col>

        <!-- 平均稼働率 -->
        <v-col cols="6" md="2" class="d-flex align-center">
          <v-avatar size="44" color="warning" rounded class="elevation-1">
            <v-icon dark color="white" size="30">
              {{ icons.mdiLabelOutline }}
            </v-icon>
          </v-avatar>
          <div class="ms-3">
            <p class="text-xs mb-0">{{ $t('Average Work Rate') }}</p>
            <h3 class="text-xl font-weight-semibold">
              {{ parseFloat(teamData.avgWorkRate).toFixed(2) }}
            </h3>
          </div>
        </v-col>

        <!-- ドキュメント数 -->
        <v-col cols="6" md="2" class="d-flex align-center">
          <v-avatar size="44" color="info" rounded class="elevation-1">
            <v-icon dark color="white" size="30">
              {{ icons.mdiFileDocumentOutline }}
            </v-icon>
          </v-avatar>
          <div class="ms-3">
            <p class="text-xs mb-0">{{ $t('Number of Documents') }}</p>
            <h3 class="text-xl font-weight-semibold">
              {{ teamData.numDocuments }}
            </h3>
          </div>
        </v-col>

        <!-- 平均リードタイム -->
        <v-col cols="6" md="2" class="d-flex align-center">
          <v-avatar size="44" color="error" rounded class="elevation-1">
            <v-icon dark color="white" size="30">
              {{ icons.mdiBookClockOutline }}
            </v-icon>
          </v-avatar>
          <div class="ms-3">
            <p class="text-xs mb-0">{{ $t('Average Lead Time') }}</p>
            <h3 class="text-xl font-weight-semibold">
              {{ parseFloat(teamData.avgLeadTime).toFixed(2) }}
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
  mdiLabelOutline,
  mdiFileDocumentOutline,
  mdiMessageReplyTextOutline,
  mdiBookClockOutline,
} from '@mdi/js'
import { watch, ref } from '@vue/composition-api'

export default {
  props: {
    teamData: {
      type: Object,
      required: true,
    },
  },
  setup(props, { emit }) {
    const teamDataLocal = ref({})
    teamDataLocal.value = JSON.parse(JSON.stringify(props.teamData))

    watch(
      () => props.teamData,
      () => {
        teamDataLocal.value = JSON.parse(JSON.stringify(props.teamData))
      },
    )

    return {
      teamDataLocal,

      // icons
      icons: {
        mdiTrendingUp,
        mdiAccountOutline,
        mdiFileDocumentOutline,
        mdiLabelOutline,
        mdiCurrencyUsd,
        mdiBookClockOutline,
      },
    }
  },
}
</script>
