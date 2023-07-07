import { ref, watch } from '@vue/composition-api'
import chartjsData from './chartjsData'
import moment from 'moment'

export default function useTeamTabOverview(props) {
  const localProjectList = ref([])

  const projectTableHeaders = [
    { text: 'Project Name', value: 'project_name', sortable: false },
    { text: 'Project Phase', value: 'project_phase', sortable: false },
    { text: 'Progress Rate', value: 'progress_rate', sortable: false },
  ]

  const resolveTeamProgressVariant = progrss => {
    if (progrss <= 25) return 'error'
    if (progrss > 25 && progrss <= 50) return 'warning'
    if (progrss > 50 && progrss <= 75) return 'primary'
    if (progrss > 75 && progrss <= 100) return 'success'

    return 'secondary'
  }

  const velocityTransGraphData = ref({})
  const avgLeadTimeTransGraphData = ref({})
  const numNewTicketTransGraphData = ref({})
  const numPullRequestsTransGraphData = ref({})
  const numPrsMergedTransGraphData = ref({})
  const numMessagesTransGraphData = ref({})

  const topNumCommentsData = ref([])
  const topNumPullRequestsData = ref([])
  const topNumMessagesData = ref([])
  const topAvgLeadTimeData = ref([])

  const lineGraphChartOption = ref(JSON.parse(JSON.stringify(chartjsData.lineChart.options)))
  const barGraphChartOption = ref(JSON.parse(JSON.stringify(chartjsData.latestBarChart.options)))

  watch(
    () => props.teamData,
    (value, prevValue) => {
      localProjectList.value = JSON.parse(JSON.stringify(value.projects))

      const {
        velocityTransitions,
        avgLeadTimeTransitions,
        numNewTicketTransitions,
        numPullRequestsTransitions,
        numPrsMergedTransitions,
        numMessagesTransitions,
        topNumComments,
        topNumPullRequests,
        topNumMessages,
        topAvgLeadTime,
      } = value

      velocityTransGraphData.value = makeGraphData(velocityTransitions)
      avgLeadTimeTransGraphData.value = makeGraphData(avgLeadTimeTransitions)
      numNewTicketTransGraphData.value = makeGraphData(numNewTicketTransitions)
      numPullRequestsTransGraphData.value = makeGraphData(numPullRequestsTransitions)
      numPrsMergedTransGraphData.value = makeGraphData(numPrsMergedTransitions)
      numMessagesTransGraphData.value = makeGraphData(numMessagesTransitions)
      topNumCommentsData.value = topNumComments
      topNumPullRequestsData.value = topNumPullRequests
      topNumMessagesData.value = topNumMessages
      topAvgLeadTimeData.value = topAvgLeadTime
    },
  )

  const makeGraphData = transitions => {
    let values = transitions.map(v => parseFloat(v.sum).toFixed(2))
    let labels = transitions.map(v => moment(v.endDate).format('MM/DD'))
    let localChartData = JSON.parse(JSON.stringify(chartjsData.lineChart.data))
    localChartData.datasets[0].data = [...values]
    localChartData.labels = [...labels]
    return localChartData
  }

  return {
    localProjectList,
    projectTableHeaders,
    resolveTeamProgressVariant,

    lineGraphChartOption,
    barGraphChartOption,
    velocityTransGraphData,
    avgLeadTimeTransGraphData,
    numNewTicketTransGraphData,
    numPullRequestsTransGraphData,
    numPrsMergedTransGraphData,
    numMessagesTransGraphData,

    topNumCommentsData,
    topNumPullRequestsData,
    topNumMessagesData,
    topAvgLeadTimeData,
  }
}
