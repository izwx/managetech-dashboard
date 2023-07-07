<template>
  <div class="team-tab-overview">
    <!-- team name & statistic card -->
    <v-row>
      <v-col cols="12" md="12">
        <team-statistics-card :team-data="teamData"></team-statistics-card>
      </v-col>

      <v-col cols="12" md="12">
        <!-- team project list -->
        <v-card class="mb-7">
          <v-card-title>
            {{ $t('Projects') }}
          </v-card-title>

          <v-data-table
            :headers="projectTableHeaders"
            :items="localProjectList"
            hide-default-header
            hide-default-footer
          >
            <template #header="{ props: { headers } }">
              <thead class="v-data-table-header">
                <tr>
                  <th
                    v-for="header in headers"
                    :key="header.value"
                    class="text-uppercase"
                    :class="{ 'text-right': header.align == 'right' }"
                    scope="col"
                  >
                    {{ $t(header.text) }}
                  </th>
                </tr>
              </thead>
            </template>
            <!-- project -->
            <template #[`item.project_name`]="{ item }">
              <div class="d-flex align-center">
                <router-link
                  :to="{ name: 'project-view', params: { id: item.id } }"
                  class="text-no-wrap text-decoration-none"
                >
                  <p class="font-weight-medium mb-n1">
                    {{ item.projectName }}
                  </p>
                  <span class="text-xs text--disabled">#{{ item.id }}</span>
                </router-link>
              </div>
            </template>

            <!-- project phase -->
            <template #[`item.project_phase`]="{ item }">
              <v-chip
                small
                :color="phaseColor[item.projectPhase]"
                :class="`${phaseColor[item.projectPhase]}--text`"
                class="v-chip-light-bg font-weight-semibold text-capitalize"
              >
                {{ $t(`${item.projectPhase}`) }}
              </v-chip>
            </template>

            <!-- progress_rate -->
            <template #[`item.progress_rate`]="{ item }">
              <span>{{ parseFloat(item.progressRate).toFixed(2) }}%</span>
              <v-progress-linear
                height="6"
                rounded
                class="project-progress mt-1"
                :color="resolveTeamProgressVariant(item.progressRate)"
                :value="parseFloat(item.progressRate).toFixed(2)"
              ></v-progress-linear>
            </template>
          </v-data-table>
        </v-card>
      </v-col>

      <!-- velocity transition graph -->
      <v-col cols="6" md="6">
        <v-card>
          <v-card-title>
            <span>{{ $t('Velocity Statistics') }}</span>
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
      <!-- average leadtime transition graph -->
      <v-col cols="6" md="6">
        <v-card>
          <v-card-title>
            <span>{{ $t('Average Lead Time Statistics') }}</span>
            <v-spacer></v-spacer>
          </v-card-title>

          <!-- chart -->
          <v-card-text class="mt-2">
            <chartjs-component-line-chart
              :height="400"
              :data="avgLeadTimeTransGraphData"
              :options="lineGraphChartOption"
            />
          </v-card-text>
        </v-card>
      </v-col>
      <!-- num new tickets transitions -->
      <v-col cols="6" md="6">
        <v-card>
          <v-card-title>
            <span>{{ $t('New Tickets Statistics') }}</span>
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
            <span>{{ $t('Pull Requests Statistics') }}</span>
            <v-spacer></v-spacer>
          </v-card-title>

          <!-- chart -->
          <v-card-text class="mt-5">
            <chartjs-component-bar-chart
              :height="400"
              :data="numPullRequestsTransGraphData"
              :options="barGraphChartOption"
            />
          </v-card-text>
        </v-card>
      </v-col>

      <!-- num PR merged transition graph -->
      <v-col cols="6" md="6">
        <v-card>
          <v-card-title>
            <span>{{ $t('Merged PRs Statisticts') }}</span>
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
            <span>{{ $t('Messages Statisticts') }}</span>
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
    </v-row>

    <v-row>
      <v-col cols="3" md="3">
        <top-developer-list-card
          :list="topNumCommentsData"
          :title="$t('Top PRs Comments Developers')"
        ></top-developer-list-card>
      </v-col>
      <v-col cols="3" md="3">
        <top-developer-list-card :list="topNumPullRequestsData" :title="$t('PRs TOP5')"></top-developer-list-card>
      </v-col>
      <v-col cols="3" md="3">
        <top-developer-list-card :list="topNumMessagesData" :title="$t('Messages TOP5')"></top-developer-list-card>
      </v-col>
      <v-col cols="3" md="3">
        <top-developer-list-card
          :list="topAvgLeadTimeData"
          :title="$t('Average Lead Time TOP5')"
        ></top-developer-list-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import TeamStatisticsCard from './TeamStatisticsCard.vue'
import TopDeveloperListCard from './TopDeveloperListCard.vue'
import { avatarText } from '@core/utils/filter'
import ChartjsComponentBarChart from '@/views/charts-and-maps/charts/chartjs/charts-components/ChartjsComponentBarChart.vue'
import ChartjsComponentLineChart from '@/views/charts-and-maps/charts/chartjs/charts-components/ChartjsComponentLineChart.vue'
import useTeamTabOverview from './useTeamTabOverview'

export default {
  props: {
    teamData: {
      type: Object,
      required: true,
    },
  },
  components: {
    TeamStatisticsCard,
    ChartjsComponentBarChart,
    ChartjsComponentLineChart,
    TopDeveloperListCard,
  },
  setup(props) {
    const phaseColor = {
      /* eslint-disable key-spacing */
      new: 'info',
      maintenance: 'warning',
      update: 'error',
      /* eslint-enable key-spacing */
    }

    const {
      localProjectList,
      projectTableHeaders,
      resolveTeamProgressVariant,
      velocityTransGraphData,
      avgLeadTimeTransGraphData,
      numNewTicketTransGraphData,
      numPullRequestsTransGraphData,
      numPrsMergedTransGraphData,
      numMessagesTransGraphData,
      lineGraphChartOption,
      barGraphChartOption,
      topNumCommentsData,
      topNumPullRequestsData,
      topNumMessagesData,
      topAvgLeadTimeData,
    } = useTeamTabOverview(props)

    return {
      phaseColor,
      projectTableHeaders,
      localProjectList,
      resolveTeamProgressVariant,
      avatarText,

      velocityTransGraphData,
      avgLeadTimeTransGraphData,
      numNewTicketTransGraphData,
      numPullRequestsTransGraphData,
      numPrsMergedTransGraphData,
      numMessagesTransGraphData,

      lineGraphChartOption,
      barGraphChartOption,

      topNumCommentsData,
      topNumPullRequestsData,
      topNumMessagesData,
      topAvgLeadTimeData,
    }
  },
}
</script>

<style lang="scss" scoped>
.project-progress {
  min-width: 4rem;
}
</style>
