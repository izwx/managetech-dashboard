import { ref, watch } from '@vue/composition-api'
import chartjsData from './chartjsData'
import moment from 'moment'

export default function useDeveloperTabOverview(props) {
  const localTeamList = ref([])

  const teamTableHeaders = [
    {
      text: 'Team Name',
      value: 'team_name',
      sortable: false,
    },
    { text: 'Average Work Rate', value: 'avg_work_rate', sortable: false },
    { text: 'Number of Documents', value: 'num_documents', sortable: false },
    { text: 'Average Lead Time', value: 'avg_lead_time', sortable: false },
  ]

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

  const skillListData = ref([])
  const domainListData = ref([])

  const lineGraphChartOption = ref(JSON.parse(JSON.stringify(chartjsData.lineChart.options)))
  const barGraphChartOption = ref(JSON.parse(JSON.stringify(chartjsData.latestBarChart.options)))

  watch(
    () => props.developerData,
    (value, prevValue) => {
      localTeamList.value = JSON.parse(JSON.stringify(value.teams))

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
        skillCareers,
        domainCareers,
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
      skillListData.value = skillCareers
      domainListData.value = domainCareers
    },
  )

  const makeGraphData = transitions => {
    let values = transitions.map(v => parseFloat(v.avg).toFixed(2))
    let labels = transitions.map(v => moment(v.endDate).format('MM/DD'))
    let localChartData = JSON.parse(JSON.stringify(chartjsData.lineChart.data))
    localChartData.datasets[0].data = [...values]
    localChartData.labels = [...labels]
    return localChartData
  }

  return {
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
}
