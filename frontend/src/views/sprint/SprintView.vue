<template>
  <div id="sprint-view">
    <v-row>
      <v-col cols="4" md="4">
        <sprint-title-card :title="sprintData.name"></sprint-title-card>
      </v-col>
      <v-col cols="2" md="2">
        <statistics-card-vertical
          color="info"
          :icon="icons.mdiChartTimelineVariant"
          :statistics="`${sprintData.numTicket}`"
          :change="numTicketChange"
          stat-title="チケット数"
          subtitle="Number of Tickets"
        ></statistics-card-vertical>
      </v-col>
      <v-col cols="2" md="2">
        <statistics-card-vertical
          color="warning"
          :icon="icons.mdiMapClockOutline"
          :statistics="`${sprintData.totalWorkHour}`"
          :change="totalWorkHourChange"
          stat-title="総工数"
          subtitle="Total work hours"
        ></statistics-card-vertical>
      </v-col>
      <v-col cols="2" md="2">
        <statistics-card-vertical
          color="primary"
          :icon="icons.mdiBookClockOutline"
          :statistics="`${parseFloat(avgWorkHour).toFixed(2)}`"
          :change="`${avgWorkHourChange}`"
          stat-title="総工数/チーム人数"
          subtitle="Average work hours"
        ></statistics-card-vertical>
      </v-col>
      <v-col cols="2" md="2">
        <statistics-card-vertical
          color="success"
          :icon="icons.mdiClockTimeOneOutline"
          :statistics="`${sprintData.closeWorkHour}`"
          :change="closeWorkHourChange"
          stat-title="完了工数"
          subtitle="Close work hours"
        ></statistics-card-vertical>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="2" md="2">
        <statistics-card-vertical
          color="error"
          :icon="icons.mdiChartTimelineVariantShimmer"
          :statistics="`${parseFloat(sprintData.velocity).toFixed(2)}`"
          :change="velocityChange"
          stat-title="ベロシティ"
          subtitle="Velocity"
        ></statistics-card-vertical>
      </v-col>
      <v-col cols="2" md="2">
        <statistics-card-vertical
          color="success"
          :icon="icons.mdiCallMissed"
          :statistics="`${parseFloat(sprintData.avgWorkRate).toFixed(2)}`"
          :change="avgWorkRateChange"
          stat-title="平均稼働率"
          subtitle="Average work rate"
        ></statistics-card-vertical>
      </v-col>
      <v-col cols="2" md="2">
        <statistics-card-vertical
          color="secondary"
          :icon="icons.mdiChartMultiline"
          :statistics="`${sprintData.numNewTicket}`"
          :change="numNewTicketChange"
          stat-title="新規チケット数"
          subtitle="Close work hours"
        ></statistics-card-vertical>
      </v-col>
      <v-col cols="2" md="2">
        <statistics-card-vertical
          color="primary"
          :icon="icons.mdiFinance"
          :statistics="`${sprintData.numPullRequest}`"
          :change="numPullRequestChange"
          stat-title="プルリク数"
          subtitle="Close work hours"
        ></statistics-card-vertical>
      </v-col>
      <v-col cols="2" md="2">
        <statistics-card-vertical
          color="warning"
          :icon="icons.mdiFormatRotate90"
          :statistics="`${sprintData.numPrsMerged}`"
          :change="numPrsMergedChange"
          stat-title="マージ済PR数"
          subtitle="Close work hours"
        ></statistics-card-vertical>
      </v-col>
      <v-col cols="2" md="2">
        <statistics-card-vertical
          color="info"
          :icon="icons.mdiAbacus"
          :statistics="`${sprintData.numMessages}`"
          :change="numMessagesChange"
          stat-title="メッセージ数"
          subtitle="Close work hours"
        ></statistics-card-vertical>
      </v-col>
    </v-row>

    <v-row>
      <!-- num backlogs transition graph -->
      <v-col cols="6" md="6">
        <v-card>
          <v-card-title>
            <span>バックログ数遷移グラフ</span>
            <v-spacer></v-spacer>
          </v-card-title>
          <v-card-text class="mt-2">
            <chartjs-component-bar-chart
              :height="400"
              :data="numBacklogTransGraphData"
              :options="barGraphChartOption"
            />
          </v-card-text>
        </v-card>
      </v-col>
      <!-- velocity transition graph -->
      <v-col cols="6" md="6">
        <v-card>
          <v-card-title>
            <span>ベロシティ遷移グラフ</span>
            <v-spacer></v-spacer>
          </v-card-title>
          <v-card-text class="mt-2">
            <chartjs-component-line-chart
              :height="400"
              :data="velocityTransGraphData"
              :options="lineGraphChartOption"
            />
          </v-card-text>
        </v-card>
      </v-col>
      <!-- num new tickets transitions -->
      <v-col cols="6" md="6">
        <v-card>
          <v-card-title>
            <span>新規チケット遷移グラフ</span>
            <v-spacer></v-spacer>
          </v-card-title>

          <!-- chart -->
          <v-card-text class="mt-5">
            <chartjs-component-bar-chart
              :height="400"
              :data="numNewTicketTransGraphData"
              :options="barGraphChartOption"
            />
          </v-card-text>
        </v-card>
      </v-col>
      <!-- num pull request transitions -->
      <v-col cols="6" md="6">
        <v-card>
          <v-card-title>
            <span>プルリク数遷移グラフ</span>
            <v-spacer></v-spacer>
          </v-card-title>

          <!-- chart -->
          <v-card-text class="mt-5">
            <chartjs-component-bar-chart
              :height="400"
              :data="numPullRequestTransGraphData"
              :options="barGraphChartOption"
            />
          </v-card-text>
        </v-card>
      </v-col>
      <!-- num PR merged transition graph -->
      <v-col cols="6" md="6">
        <v-card>
          <v-card-title>
            <span>マージ済PR数遷移グラフ</span>
            <v-spacer></v-spacer>
          </v-card-title>
          <v-card-text class="mt-2">
            <chartjs-component-bar-chart
              :height="400"
              :data="numPrsMergedTransGraphData"
              :options="barGraphChartOption"
            />
          </v-card-text>
        </v-card>
      </v-col>

      <!-- num messages transition graph -->
      <v-col cols="6" md="6">
        <v-card>
          <v-card-title>
            <span>メッセージ数遷移グラフ</span>
            <v-spacer></v-spacer>
          </v-card-title>
          <v-card-text class="mt-2">
            <chartjs-component-bar-chart
              :height="400"
              :data="numMessagesTransGraphData"
              :options="barGraphChartOption"
            />
          </v-card-text>
        </v-card>
      </v-col>

      <!-- unclosed tickets -->
      <v-col cols="6" md="6">
        <top-list-card :list="unclosedTicketsData" title="完了していないチケットのリスト"></top-list-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import { onUnmounted } from '@vue/composition-api'
import store from '@/store'
import sprintStoreModule from '@/store/modules/sprintStoreModule'
import useSprintView from './useSprintView'

import SprintTitleCard from './SprintTitleCard.vue'
import StatisticsCardVertical from './StatisticsCardVertical.vue'
import ChartjsComponentBarChart from '@/views/charts-and-maps/charts/chartjs/charts-components/ChartjsComponentBarChart.vue'
import ChartjsComponentLineChart from '@/views/charts-and-maps/charts/chartjs/charts-components/ChartjsComponentLineChart.vue'
import TopListCard from './TopListCard.vue'
import {
  mdiChartTimelineVariant,
  mdiMapClockOutline,
  mdiCallMissed,
  mdiBookClockOutline,
  mdiClockTimeOneOutline,
  mdiChartTimelineVariantShimmer,
  mdiChartMultiline,
  mdiFinance,
  mdiFormatRotate90,
  mdiAbacus,
} from '@mdi/js'

export default {
  components: {
    SprintTitleCard,
    StatisticsCardVertical,
    ChartjsComponentBarChart,
    ChartjsComponentLineChart,
    TopListCard,
  },
  setup() {
    const SPRINT_APP_STORE_MODULE_NAME = 'app-sprint'

    // Register module
    if (!store.hasModule(SPRINT_APP_STORE_MODULE_NAME))
      store.registerModule(SPRINT_APP_STORE_MODULE_NAME, sprintStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(SPRINT_APP_STORE_MODULE_NAME)) store.unregisterModule(SPRINT_APP_STORE_MODULE_NAME)
    })

    const {
      sprintData,
      numTicketChange,
      totalWorkHourChange,
      avgWorkHour,
      avgWorkHourChange,
      closeWorkHourChange,
      velocityChange,
      avgWorkRateChange,
      numNewTicketChange,
      numPullRequestChange,
      numPrsMergedChange,
      numMessagesChange,
      lineGraphChartOption,
      barGraphChartOption,
      numBacklogTransGraphData,
      velocityTransGraphData,
      numNewTicketTransGraphData,
      numPullRequestTransGraphData,
      numPrsMergedTransGraphData,
      numMessagesTransGraphData,
      unclosedTicketsData,
    } = useSprintView()

    return {
      sprintData,
      numTicketChange,
      totalWorkHourChange,
      avgWorkHour,
      avgWorkHourChange,
      closeWorkHourChange,
      velocityChange,
      avgWorkRateChange,
      numNewTicketChange,
      numPullRequestChange,
      numPrsMergedChange,
      numMessagesChange,
      lineGraphChartOption,
      barGraphChartOption,
      numBacklogTransGraphData,
      velocityTransGraphData,
      numNewTicketTransGraphData,
      numPullRequestTransGraphData,
      numPrsMergedTransGraphData,
      numMessagesTransGraphData,
      unclosedTicketsData,

      icons: {
        mdiChartTimelineVariant,
        mdiMapClockOutline,
        mdiCallMissed,
        mdiBookClockOutline,
        mdiClockTimeOneOutline,
        mdiChartTimelineVariantShimmer,
        mdiChartMultiline,
        mdiFinance,
        mdiFormatRotate90,
        mdiAbacus,
      },
    }
  },
}
</script>
