<template>
  <div class="developer-tab-overview">
    <!-- developer name & statistic card -->
    <v-row>
      <v-col cols="12" md="12">
        <developer-statistics-card :developer-data="developerData"></developer-statistics-card>
      </v-col>

      <v-col cols="12" md="12">
        <!-- developer project list -->
        <v-card class="mb-7">
          <v-card-title>
            {{ $t('Teams') }}
          </v-card-title>

          <v-data-table :headers="teamTableHeaders" :items="localTeamList" hide-default-header hide-default-footer>
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
            <!-- team name -->
            <template #[`item.team_name`]="{ item }">
              <div class="d-flex align-center">
                <div class="d-flex flex-column ms-3 align-center">
                  <router-link
                    :to="{ name: 'team-view', params: { id: item.id } }"
                    class="text-no-wrap text-decoration-none"
                  >
                    <p class="font-weight-medium text--primary mb-n1">{{ item.teamName }}</p>
                    <span class="text-xs text--disabled">#{{ item.id }}</span>
                  </router-link>
                </div>
              </div>
            </template>

            <!-- average work rate -->
            <template #[`item.avg_work_rate`]="{ item }">
              <span>{{ parseFloat(item.avgWorkRate).toFixed(2) || 0 }}</span>
            </template>
            <!-- num documents -->
            <template #[`item.num_documents`]="{ item }">
              <span>{{ item.numDocuments || 0 }}</span>
            </template>
            <!-- average lead time -->
            <template #[`item.avg_lead_time`]="{ item }">
              <span>{{ parseFloat(item.avgLeadTime).toFixed(2) || 0 }}</span>
            </template>
          </v-data-table>
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
        <skills-card :title="$t('Skill List')" :data="skillListData"></skills-card>
      </v-col>
      <v-col cols="4" md="4">
        <domains-card :title="$t('Domain List')" :data="domainListData"></domains-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import { avatarText } from '@core/utils/filter'
import DeveloperStatisticsCard from './DeveloperStatisticsCard.vue'
import ChartjsComponentBarChart from '@/views/charts-and-maps/charts/chartjs/charts-components/ChartjsComponentBarChart.vue'
import ChartjsComponentLineChart from '@/views/charts-and-maps/charts/chartjs/charts-components/ChartjsComponentLineChart.vue'
import SkillsCard from './SkillsCard.vue'
import DomainsCard from './DomainsCard.vue'
import useDeveloperTabOverView from './useDeveloperTabOverView'

export default {
  props: {
    developerData: {
      type: Object,
      required: true,
    },
  },
  components: { DeveloperStatisticsCard, ChartjsComponentBarChart, ChartjsComponentLineChart, SkillsCard, DomainsCard },
  setup(props) {
    const {
      localTeamList,
      teamTableHeaders,

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

      skillListData,
      domainListData,
    } = useDeveloperTabOverView(props)

    return {
      avatarText,
      localTeamList,
      teamTableHeaders,

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

      skillListData,
      domainListData,
    }
  },
}
</script>

<style lang="scss" scoped>
.project-progress {
  min-width: 4rem;
}
</style>
