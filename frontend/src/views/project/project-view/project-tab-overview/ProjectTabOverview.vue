<template>
  <div class="project-tab-overview">
    <!-- project name & statistic card -->
    <v-row>
      <v-col cols="8" md="8">
        <v-row>
          <v-col cols="12">
            <project-title-card :title="projectData.projectName" :sprint-title="sprintTitle"></project-title-card>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="4">
            <statistics-card-vertical
              color="error"
              :icon="icons.mdiTrendingUp"
              :statistics="parseFloat(projectData.avgVelocity).toFixed(2)"
              :stat-title="$t('Average Velocity')"
              subtitle="Average velocity"
            ></statistics-card-vertical>
          </v-col>
          <v-col cols="4">
            <statistics-card-vertical
              color="warning"
              :icon="icons.mdiCheck"
              :statistics="parseFloat(projectData.avgWorkRate).toFixed(2)"
              :stat-title="$t('Average Work Rate')"
              subtitle="Average work rate"
            ></statistics-card-vertical>
          </v-col>
          <v-col cols="4">
            <statistics-card-vertical
              color="info"
              :icon="icons.mdiChartTimelineVariant"
              :statistics="`${projectData.numDocuments}`"
              :stat-title="$t('Number of Documents')"
              subtitle="Number of Documents"
            ></statistics-card-vertical>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="8" md="8">
            <activity-timeline :release-date="localExpectReleaseDate"></activity-timeline>
          </v-col>
          <v-col cols="4" md="4">
            <lead-time-analytics
              :avgLeadTime="parseFloat(projectData.avgLeadTime).toFixed(2) || 0"
              :avgLeadTimeBacklog="
                (parseFloat(projectData.avgLeadTime) * parseFloat(projectData.remainWorkHour)).toFixed(2) || 0
              "
            ></lead-time-analytics>
          </v-col>
        </v-row>
      </v-col>
      <v-col cols="4" md="4">
        <div class="mb-4">
          <progress-card
            :stat-title="$t('Progress Rate')"
            :chart-series="raidalChartSeries"
            :chart-color="$vuetify.theme.currentTheme.info"
          >
          </progress-card>
        </div>
        <team-list-card :team-list="projectData.teams"></team-list-card>
      </v-col>
    </v-row>
    <v-row>
      <!-- num backlog transitions -->
      <v-col cols="6" md="6">
        <v-card>
          <v-card-title>
            <span>{{ $t('Backlogs Statistics') }}</span>
            <v-spacer></v-spacer>
          </v-card-title>
          <!-- chart -->
          <v-card-text class="mt-5">
            <chartjs-component-bar-chart
              :height="400"
              :data="numBacklogTransGraphData"
              :options="barGraphChartOption"
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
          <v-card-text class="mt-5">
            <chartjs-component-line-chart
              :height="400"
              :data="avgLeadTimeTransGraphData"
              :options="lineGraphChartOption"
            />
          </v-card-text>
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
      <v-col cols="4" md="4">
        <top-developer-list-card
          :list="lowWorkRatesData"
          :title="$t('Low Work Rate Developers')"
        ></top-developer-list-card>
      </v-col>
      <v-col cols="4" md="4">
        <top-developer-list-card
          :list="topNumCommentsData"
          :title="$t('Top PRs Comments Developers')"
        ></top-developer-list-card>
      </v-col>
      <v-col cols="4" md="4">
        <top-list-card :list="topPullRequestsData" :title="$t('Top Commented PRs')"></top-list-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="4" md="4">
        <top-list-card :list="longOpenedTicketsData" :title="$t('Tickets open for more than 10 days')"></top-list-card>
      </v-col>
      <v-col cols="4" md="4">
        <top-list-card :list="longUnclosedTicketsData" :title="$t('Tickets delayed more than 5 days')"></top-list-card>
      </v-col>
      <v-col cols="4" md="4">
        <top-list-card :list="longReviewedPrsData" :title="$t('PRs with long review times')"></top-list-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12">
        <v-card>
          <v-card-title>
            {{ $t('Sprints') }}
          </v-card-title>

          <!-- table -->
          <v-data-table :headers="tableColumnHeaders" :items="sprintsListTable" hide-default-header hide-default-footer>
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
            <!-- sprint name -->
            <template #[`item.name`]="{ item }">
              <div class="d-flex flex-column ms-3">
                <router-link
                  :to="{ name: 'sprint-view', params: { id: item.id } }"
                  class="font-weight-semibold text-truncate cursor-pointer text-decoration-none"
                >
                  {{ item.name }}
                </router-link>
                <span class="text-xs">#{{ item.id }}</span>
              </div>
            </template>
            <!-- start date -->
            <template #[`item.start_date`]="{ item }">
              <div class="d-flex align-center">
                <span class="text--primary">{{ item.startDate }}</span>
              </div>
            </template>
            <!-- end date -->
            <template #[`item.end_date`]="{ item }">
              <span class="text--primary">{{ item.endDate }}</span>
            </template>
            <!-- velocity -->
            <template #[`item.velocity`]="{ item }">
              <span class="text--primary">{{ parseFloat(item.velocity).toFixed(2) }}</span>
            </template>
            <!-- total work hours -->
            <template #[`item.total_work_hour`]="{ item }">
              <span class="text--primary">{{ item.totalWorkHour }}</span>
            </template>
            <!-- close work hours -->
            <template #[`item.close_work_hour`]="{ item }">
              <span class="text--primary">{{ item.closeWorkHour }}</span>
            </template>
          </v-data-table>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import { mdiDotsVertical, mdiCurrencyUsd, mdiCheck, mdiTrendingUp, mdiChartTimelineVariant } from '@mdi/js'
import ProjectTitleCard from './ProjectTitleCard.vue'
import TeamListCard from './TeamListCard.vue'
import ProgressCard from './ProgressCard.vue'
import StatisticsCardVertical from './StatisticsCardVertical.vue'
import LeadTimeAnalytics from './LeadTimeAnalytics.vue'
import ActivityTimeline from './ActivityTimeline.vue'
import moment from 'moment'
import { ref, watch } from '@vue/composition-api'
import ChartjsComponentBarChart from '@/views/charts-and-maps/charts/chartjs/charts-components/ChartjsComponentBarChart.vue'
import ChartjsComponentLineChart from '@/views/charts-and-maps/charts/chartjs/charts-components/ChartjsComponentLineChart.vue'
import TopListCard from './TopListCard.vue'
import TopDeveloperListCard from './TopDeveloperListCard.vue'
import useProjectTabOverview from './useProjectTabOverview'

export default {
  props: {
    projectData: {
      type: Object,
      required: true,
    },
  },
  components: {
    ProjectTitleCard,
    TeamListCard,
    ProgressCard,
    StatisticsCardVertical,
    LeadTimeAnalytics,
    ActivityTimeline,
    ChartjsComponentBarChart,
    ChartjsComponentLineChart,
    TopListCard,
    TopDeveloperListCard,
  },
  setup(props) {
    const {
      lineGraphChartOption,
      barGraphChartOption,
      numBacklogTransGraphData,
      avgLeadTimeTransGraphData,
      velocityTransGraphData,
      numNewTicketTransGraphData,
      numPullRequestsTransGraphData,
      numPrsMergedTransGraphData,
      numMessagesTransGraphData,
      lowWorkRatesData,
      topNumCommentsData,
      topPullRequestsData,
      longOpenedTicketsData,
      longUnclosedTicketsData,
      longReviewedPrsData,
      tableColumnHeaders,
      sprintsListTable,
    } = useProjectTabOverview(props)
    const salesRadialChart = {
      series: [0],
    }
    const localExpectReleaseDate = ref(null)
    const sprintTitle = ref('')
    const raidalChartSeries = ref([0])

    watch(
      () => props.projectData,
      (value, preValue) => {
        localExpectReleaseDate.value = moment(value.expectReleaseDate)
        sprintTitle.value = props.projectData.currentSprint?.name
        raidalChartSeries.value = [parseFloat(props.projectData.progressRate).toFixed(1)]
      },
    )

    return {
      salesRadialChart,
      raidalChartSeries,
      localExpectReleaseDate,
      sprintTitle,

      numBacklogTransGraphData,
      lineGraphChartOption,
      barGraphChartOption,
      avgLeadTimeTransGraphData,
      velocityTransGraphData,
      numNewTicketTransGraphData,
      numPullRequestsTransGraphData,
      numPrsMergedTransGraphData,
      numMessagesTransGraphData,
      lowWorkRatesData,
      topNumCommentsData,
      topPullRequestsData,
      longOpenedTicketsData,
      longUnclosedTicketsData,
      longReviewedPrsData,

      tableColumnHeaders,
      sprintsListTable,

      icons: {
        mdiDotsVertical,
        mdiCurrencyUsd,
        mdiTrendingUp,
        mdiCheck,
        mdiChartTimelineVariant,
      },
    }
  },
}
</script>

<style lang="scss" scoped>
.project-progress {
  min-width: 4rem;
}
</style>
