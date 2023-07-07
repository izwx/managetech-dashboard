<template>
  <v-card>
    <v-card-title class="align-start">
      <span class="text-xl font-weight-semibold primary--text mb-2">
        {{ developerData.developerName }}
      </span>
      <v-spacer></v-spacer>
    </v-card-title>

    <v-card-text>
      <v-row>
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
              <span v-if="developerDataLocal.avgVelocity">{{ parseFloat(developerDataLocal.avgVelocity).toFixed(2)}}</span>
              <span v-else>0</span>
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
              <span v-if="developerDataLocal.avgWorkRate">{{ parseFloat(developerDataLocal.avgWorkRate).toFixed(2)}}</span>
              <span v-else>0</span>
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
              <span v-if="developerDataLocal.numDocuments">{{ parseFloat(developerDataLocal.numDocuments).toFixed(2) }}</span>
              <span>0</span>
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
              <span v-if="developerDataLocal.avgLeadTime">{{ parseFloat(developerDataLocal.avgLeadTime).toFixed(2) }}</span>
              <span v-else>0</span>
            </h3>
          </div>
        </v-col>

        <!-- レビュー数 -->
        <v-col cols="6" md="2" class="d-flex align-center">
          <v-avatar size="44" color="primary" rounded class="elevation-1">
            <v-icon dark color="white" size="30">
              {{ icons.mdiMessageDraw }}
            </v-icon>
          </v-avatar>
          <div class="ms-3">
            <p class="text-xs mb-0">{{ $t('Average Reviews') }}</p>
            <h3 class="text-xl font-weight-semibold">
              {{ developerDataLocal.avgReviews || 0 }}
            </h3>
          </div>
        </v-col>

        <!-- 平均レビュー時間 -->
        <v-col cols="6" md="2" class="d-flex align-center">
          <v-avatar size="44" color="secondary" rounded class="elevation-1">
            <v-icon dark color="white" size="30">
              {{ icons.mdiChartTimeline }}
            </v-icon>
          </v-avatar>
          <div class="ms-3">
            <p class="text-xs mb-0">{{ $t('Average Review Hours') }}</p>
            <h3 class="text-xl font-weight-semibold">
              {{ developerDataLocal.avgReviewHours || 0 }}
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
  mdiTrendingUp,
  mdiLabelOutline,
  mdiBookClockOutline,
  mdiFileDocumentOutline,
  mdiMessageDraw,
  mdiChartTimeline,
} from '@mdi/js'
import { watch, ref } from '@vue/composition-api'

export default {
  props: {
    developerData: {
      type: Object,
      required: true,
    },
  },
  setup(props, { emit }) {
    const developerDataLocal = ref({})
    developerDataLocal.value = JSON.parse(JSON.stringify(props.developerData))

    watch(
      () => props.developerData,
      () => {
        developerDataLocal.value = JSON.parse(JSON.stringify(props.developerData))
      },
    )

    return {
      developerDataLocal,

      // icons
      icons: {
        mdiTrendingUp,
        mdiLabelOutline,
        mdiBookClockOutline,
        mdiFileDocumentOutline,
        mdiMessageDraw,
        mdiChartTimeline,
      },
    }
  },
}
</script>
