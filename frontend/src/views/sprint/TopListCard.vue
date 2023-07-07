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
          :key="`${data.itemId}${index}`"
          :class="`d-flex align-center px-0 ${index > 0 ? 'mt-3' : ''}`"
        >
          <div class="d-flex align-center flex-grow-1 flex-wrap text-no-wrap">
            <div class="me-2">
              <v-list-item-title class="text-sm font-weight-medium">
                {{ data.itemName }}
              </v-list-item-title>

              <v-list-item-subtitle class="text-xs"> #{{ data.itemId }} </v-list-item-subtitle>
            </div>

            <v-spacer></v-spacer>

            <span class="font-weight-semibold">{{ data.rate }}</span>
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
