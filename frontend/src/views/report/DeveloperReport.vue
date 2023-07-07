<template>
  <v-card>
    <v-card-title class="align-start flex-nowrap">
      <div>
        <div class="mb-2 text-sm font-weight-semibold">
          {{ $t('Current Number of Developers') }}
        </div>
        <div>
          <span class="text-2xl font-weight-semibold me-1">{{ developerTotalCount }}</span>
        </div>
      </div>
      <v-spacer></v-spacer>
    </v-card-title>

    <!-- Chart -->
    <v-card-text>
      <vue-apex-charts height="180" :options="chartOptions" :series="chartData"></vue-apex-charts>
    </v-card-text>
  </v-card>
</template>

<script>
import { ref } from '@vue/composition-api'
import axios from '@axios'
import useReport from './useReport'

import VueApexCharts from 'vue-apexcharts'
// eslint-disable-next-line object-curly-newline
import { mdiDotsVertical, mdiChevronUp } from '@mdi/js'
import moment from 'moment'

export default {
  components: {
    VueApexCharts,
  },
  setup() {
    const { defaultChartOptions, $vuetify } = useReport()

    const developerTotalCount = ref(null)

    const chartOptions = ref(JSON.parse(JSON.stringify(defaultChartOptions)))
    const chartData = ref([
      {
        name: '現在の開発者数',
        data: [],
      },
    ])

    axios
      .get('developer_reports')
      .then(response => {
        const { developerReports } = response.data
        developerTotalCount.value = developerReports[0].value || 0
        const xAxisData = developerReports.reverse().map(obj => moment(obj.date).month() + '月')
        chartOptions.value = JSON.parse(
          JSON.stringify({
            xaxis: {
              categories: xAxisData,
            },
            colors: [$vuetify.theme.currentTheme.warning],
          }),
        )
        const yAxisData = developerReports.map(obj => obj.value)
        chartData.value = JSON.parse(
          JSON.stringify([
            {
              data: yAxisData,
            },
          ]),
        )
      })
      .catch(error => {
        console.error(error)
      })

    return {
      developerTotalCount,

      chartOptions,
      chartData,

      icons: {
        mdiDotsVertical,
        mdiChevronUp,
      },
    }
  },
}
</script>
