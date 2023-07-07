<template>
  <v-card>
    <v-card-title class="align-start">
      <span>{{ title }}</span>
      <v-spacer></v-spacer>
    </v-card-title>

    <v-card-text>
      <v-list class="pt-0">
        <v-list-item
          v-for="(data, index) in list"
          :key="`${data.developerId}${index}`"
          :class="`d-flex align-center px-0 ${index > 0 ? 'mt-3' : ''}`"
        >
          <v-list-item-avatar size="38">
            <v-img :src="require(`@/assets/images/avatars/${(data.developerId % 12) + 1}.png`)"></v-img>
          </v-list-item-avatar>
          <div class="d-flex align-center flex-grow-1 flex-wrap text-no-wrap">
            <div class="me-2">
              <router-link
                :to="{ name: 'developer-view', params: { id: data.developerId } }"
                class="text-no-wrap text-decoration-none"
              >
                <v-list-item-title class="text-sm font-weight-medium">
                  {{ data.developerName }}
                </v-list-item-title>
                <v-list-item-subtitle class="text-xs"> #{{ data.developerId }} </v-list-item-subtitle>
              </router-link>
            </div>

            <v-spacer></v-spacer>

            <span class="font-weight-semibold">{{ data.sum }}</span>
          </div>
        </v-list-item>
      </v-list>
    </v-card-text>
  </v-card>
</template>

<script>
import { mdiCalendarBlankOutline, mdiDotsVertical } from '@mdi/js'

export default {
  props: {
    list: {
      type: Array,
      default: () => [],
    },
    title: {
      type: String,
      required: true,
    },
  },
  setup() {
    return {
      icons: {
        mdiDotsVertical,
        mdiCalendarBlankOutline,
      },
    }
  },
}
</script>
