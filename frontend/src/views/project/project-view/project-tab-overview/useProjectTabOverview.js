import { ref, watch } from '@vue/composition-api'
import chartjsData from './chartjsData'
import moment from 'moment'

export default function useProjectTabOverview(props) {
  const sprintsListTable = ref([])
  const tableColumnHeaders = [
    { text: 'Sprint Name', value: 'name', sort: false },
    { text: 'Start Date', value: 'start_date', sort: false },
    { text: 'End Date', value: 'end_date', sort: false },
    { text: 'Velocity', value: 'velocity', sort: false },
    { text: 'Total Work Hours', value: 'total_work_hour', sort: false },
    { text: 'Close Work Hours', value: 'close_work_hour', sort: false },
    { text: 'Order', value: 'order', sort: false },
  ]

  const numBacklogTransGraphData = ref({})
  const avgLeadTimeTransGraphData = ref({})
  const velocityTransGraphData = ref({})
  const numNewTicketTransGraphData = ref({})
  const numPullRequestsTransGraphData = ref({})
  const numPrsMergedTransGraphData = ref({})
  const numMessagesTransGraphData = ref({})

  const lowWorkRatesData = ref([])
  const topNumCommentsData = ref([])
  const topPullRequestsData = ref([])
  const longOpenedTicketsData = ref([])
  const longUnclosedTicketsData = ref([])
  const longReviewedPrsData = ref([])

  const lineGraphChartOption = ref(JSON.parse(JSON.stringify(chartjsData.lineChart.options)))
  const barGraphChartOption = ref(JSON.parse(JSON.stringify(chartjsData.latestBarChart.options)))

  watch(
    () => props.projectData,
    (value, prevValue) => {
      const {
        numBacklogTransitions,
        avgLeadTimeTransitions,
        velocityTransitions,
        numNewTicketTransitions,
        numPullRequestsTransitions,
        numPrsMergedTransitions,
        numMessagesTransitions,
        lowWorkRates,
        topNumComments,
        topPullRequests,
        longOpenedTickets,
        longUnclosedTickets,
        longReviewedPrs,
        sprints,
      } = value

      numBacklogTransGraphData.value = makeGraphData(numBacklogTransitions)
      velocityTransGraphData.value = makeGraphData(velocityTransitions)
      avgLeadTimeTransGraphData.value = makeGraphData(avgLeadTimeTransitions)
      numNewTicketTransGraphData.value = makeGraphData(numNewTicketTransitions)
      numPullRequestsTransGraphData.value = makeGraphData(numPullRequestsTransitions)
      numPrsMergedTransGraphData.value = makeGraphData(numPrsMergedTransitions)
      numMessagesTransGraphData.value = makeGraphData(numMessagesTransitions)
      lowWorkRatesData.value = lowWorkRates.map(item => {
        return {
          itemId: item.developerId,
          itemName: item.developerName,
          rate: parseFloat(item.rate).toFixed(2),
        }
      })
      topNumCommentsData.value = topNumComments.map(item => {
        return {
          itemId: item.developerId,
          itemName: item.developerName,
          rate: parseFloat(item.rate).toFixed(2),
        }
      })
      topPullRequestsData.value = topPullRequests.map(item => {
        return {
          itemId: item.id,
          itemName: item.title,
          rate: item.rate,
        }
      })
      longOpenedTicketsData.value = longOpenedTickets.map(item => {
        let startDate = moment(item.startDate)
        let current = moment().startOf('days')
        return {
          itemId: item.id,
          itemName: item.title,
          rate: `${current.diff(startDate, 'days')}日`,
        }
      })
      longUnclosedTicketsData.value = longUnclosedTickets.map(item => {
        let endDate = moment(item.endDate)
        let current = moment().startOf('days')
        return {
          itemId: item.id,
          itemName: item.title,
          rate: `${current.diff(endDate, 'days')}日`,
        }
      })
      longReviewedPrsData.value = longReviewedPrs.map(item => {
        let createDatetime = moment(item.createDatetime)
        let current = moment().startOf('days')
        return {
          itemId: item.id,
          itemName: item.title,
          rate: `${current.diff(createDatetime, 'days')}日`,
        }
      })

      // sprints table
      sprintsListTable.value = JSON.parse(JSON.stringify(sprints))
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
  }
}
