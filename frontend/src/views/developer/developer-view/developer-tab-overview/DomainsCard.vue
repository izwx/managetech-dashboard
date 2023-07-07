<template>
  <v-card>
    <v-card-title class="align-start">
      <span>{{ title }}</span>
      <v-spacer></v-spacer>
    </v-card-title>

    <v-card-text class="mt-2">
      <div class="d-flex align-center mb-3">
        <span class="ms-2 font-weight-bold">{{ $t('Domain Name') }}</span>
        <v-spacer></v-spacer>
        <span class="font-weight-bold">{{ $t('Months') }}</span>
      </div>
      <div
        v-for="(data, index) in data"
        :key="data.title"
        :class="`statistics-table d-flex align-center pt-3 ${index > 0 ? 'mt-3' : ''}`"
      >
        <span class="ms-2">{{ data.domainName }}</span>
        <v-spacer></v-spacer>
        <span class="font-weight">{{ data.months }}</span>
      </div>
    </v-card-text>
  </v-card>
</template>

<script>
import { mdiDotsVertical, mdiChevronUp, mdiChevronDown } from '@mdi/js'
import VueApexCharts from 'vue-apexcharts'

export default {
  props: {
    title: {
      type: String,
      default: '',
    },
    data: {
      type: Array,
      default: () => [],
    },
  },
  components: {
    VueApexCharts,
  },
  setup() {
    return {
      icons: {
        mdiDotsVertical,
        mdiChevronUp,
        mdiChevronDown,
      },
    }
  },
}
</script>

<style lang="scss" scoped>
.chart-wrapper {
  max-width: 130px;
}
.statistics-table {
  border-top: solid 1px rgba(93, 89, 98, 0.14);
  .badge-sm {
    width: 0.875rem;
    height: 0.875rem;
    border-radius: 50%;
    margin: 4px;
  }
}
</style>
