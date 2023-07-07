<template>
  <v-card>
    <v-card-title class="align-start">
      <span>{{ $t('Timeline') }}</span>
      <v-spacer></v-spacer>
    </v-card-title>
    <v-card-text>
      <v-timeline dense class="timeline-custom-dense timeline-custom-dots mt-4">
        <v-timeline-item small color="primary" class="mt-4">
          <div class="d-flex justify-space-between align-center flex-wrap">
            <h4 class="font-weight-semibold me-1">
              {{ $t('Release Date') }}
            </h4>
            <small class="text-no-wrap">{{ $d(releaseDate, 'short') }}</small>
          </div>
          <p class="mb-0">
            {{ $t('releaseDateDesc') }}
          </p>
        </v-timeline-item>
      </v-timeline>
    </v-card-text>
  </v-card>
</template>

<script>
import { mdiDotsVertical, mdiFilePdf } from '@mdi/js'
export default {
  props: {
    releaseDate: {
      type: Object,
      default: () => {},
    },
  },
  setup() {
    return {
      icons: {
        mdiDotsVertical,
        mdiFilePdf,
      },
    }
  },
}
</script>
