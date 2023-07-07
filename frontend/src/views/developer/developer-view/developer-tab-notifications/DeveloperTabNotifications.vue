<template>
  <v-card class="developer-tab-notification">
    <v-card-title>
      <v-icon size="26" class="text--primary me-3">
        {{ icons.mdiChartTimelineVariant }}
      </v-icon>
      <span>{{ $t('Activity') }}</span>
    </v-card-title>

    <!-- Activity -->
    <v-card-text>
      <v-switch v-model="optionsLocale.commentOnArticle" hide-details class="mt-0">
        <template #label>
          <span class="text-sm ms-2">{{ $t('Email me when the project is updated') }}</span>
        </template>
      </v-switch>

      <v-switch v-model="optionsLocale.answerOnForm" hide-details class="mt-3">
        <template #label>
          <span class="text-sm ms-2">{{ $t('Email me when the statistics is updated') }}</span>
        </template>
      </v-switch>
    </v-card-text>

    <v-card-title class="mt-2">
      <v-icon size="26" class="text--primary me-3">
        {{ icons.mdiEmailOutline }}
      </v-icon>
      <span>{{ $t('Application') }}</span>
    </v-card-title>

    <!-- Application -->
    <v-card-text>
      <v-switch v-model="optionsLocale.newsAnnouncements" hide-details class="mt-0">
        <template #label>
          <span class="text-sm ms-2">{{ $t('Email and Accouncements') }}</span>
        </template>
      </v-switch>

      <v-switch v-model="optionsLocale.productUpdates" hide-details class="mt-3">
        <template #label>
          <span class="text-sm ms-2">{{ $t('Weekly blog digest') }}</span>
        </template>
      </v-switch>

      <v-switch v-model="optionsLocale.blogDigest" hide-details class="mt-3">
        <template #label>
          <span class="text-sm ms-2">{{ $t('Weekly product udpates') }}</span>
        </template>
      </v-switch>
    </v-card-text>

    <v-card-actions>
      <v-btn color="primary" class="me-3">
        {{ $t('Save Changes') }}
      </v-btn>
      <v-btn color="secondary" outlined>
        {{ $t('Discard') }}
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import { mdiChartTimelineVariant, mdiEmailOutline } from '@mdi/js'
import { ref } from '@vue/composition-api'

export default {
  props: {
    notificationData: {
      type: Object,
      default: () => {},
    },
  },
  setup(props) {
    const optionsLocale = ref(JSON.parse(JSON.stringify(props.notificationData)))

    return {
      optionsLocale,
      icons: { mdiChartTimelineVariant, mdiEmailOutline },
    }
  },
}
</script>
