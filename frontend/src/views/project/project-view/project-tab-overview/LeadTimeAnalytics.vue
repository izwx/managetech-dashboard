<template>
  <v-card>
    <v-card-title class="align-start">
      <span>{{ $t('Average Lead Time') }}</span>
      <v-spacer></v-spacer>
    </v-card-title>
    <v-card-text>
      <!-- 平均リードタイム -->
      <div class="d-flex align-center mt-4">
        <v-avatar size="44" color="primary" rounded class="elevation-1">
          <v-icon dark color="white" size="30">
            {{ icons.mdiTrendingUp }}
          </v-icon>
        </v-avatar>
        <div class="ms-4">
          <p class="mb-0 text-xs">
            {{ $t('Average Lead Time') }}
          </p>
          <h2 class="text-xl font-weight-semibold">{{ avgLeadTime }} h</h2>
        </div>
      </div>
      <!-- 平均リードタイム×残バックログ -->
      <div class="d-flex align-center mt-8">
        <v-avatar size="44" color="warning" rounded class="elevation-1">
          <v-icon dark color="white" size="30">
            {{ icons.mdiLabelOutline }}
          </v-icon>
        </v-avatar>
        <div class="ms-4">
          <p class="mb-0 text-xs">
            {{ $t('Average Lead Time * Remaining Backlog') }}
          </p>
          <h2 class="text-xl font-weight-semibold">{{ avgLeadTimeBacklog }} h</h2>
        </div>
      </div>
    </v-card-text>
  </v-card>
</template>

<script>
import { mdiTrendingUp, mdiLabelOutline } from '@mdi/js'
export default {
  props: {
    avgLeadTime: {
      type: [Number, String],
      default: '',
    },
    avgLeadTimeBacklog: {
      type: [Number, String],
      default: '',
    },
  },
  setup() {
    return {
      icons: {
        mdiTrendingUp,
        mdiLabelOutline,
      },
    }
  },
}
</script>
