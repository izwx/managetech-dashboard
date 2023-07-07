import store from '@/store'
import router from '@/router'
import { ref, watch, computed } from '@vue/composition-api'
import chartjsData from './chartjsData'
import moment from 'moment'

export default function useSprintView() {
  const sprintData = ref({})

  store
    .dispatch('app-sprint/fetchSprint', { id: router.currentRoute.params.id })
    .then(response => {
      const { sprint } = response.data
      sprintData.value = JSON.parse(JSON.stringify(sprint))
    })
    .catch(error => {
      console.error(error)
      sprintData.value = {}
    })

  const numTicketChange = computed(() => {
    const prevValue = sprintData.value.prevSprint?.numTicket || 0
    const diff = sprintData.value.numTicket - prevValue
    return diff > 0 ? `+${String(diff)}` : String(diff)
  })
  const totalWorkHourChange = computed(() => {
    const prevValue = sprintData.value.prevSprint?.totalWorkHour || 0
    const diff = sprintData.value.totalWorkHour - prevValue
    return diff > 0 ? `+${String(diff)}` : String(diff)
  })
  const avgWorkHour = computed(() => {
    return sprintData.value.totalWorkHour / sprintData.value.sprintMembersCount
  })
  const avgWorkHourChange = computed(() => {
    const prevValue = sprintData.value.prevSprint?.totalWorkHour / sprintData.value.prevSprint?.sprintMembersCount || 0
    const diff = parseFloat(sprintData.value.totalWorkHour / sprintData.value.sprintMembersCount - prevValue).toFixed(2)
    return diff > 0 ? `+${String(diff)}` : String(diff)
  })
  const closeWorkHourChange = computed(() => {
    const prevValue = sprintData.value.prevSprint?.closeWorkHour || 0
    const diff = sprintData.value.closeWorkHour - prevValue
    return diff > 0 ? `+${String(diff)}` : String(diff)
  })
  const velocityChange = computed(() => {
    const prevValue = sprintData.value.prevSprint?.velocity || 0
    const diff = parseFloat(sprintData.value.velocity - prevValue).toFixed(2)
    return diff > 0 ? `+${String(diff)}` : String(diff)
  })
  const avgWorkRateChange = computed(() => {
    const prevValue = sprintData.value.prevSprint?.avgWorkRate || 0
    const diff = parseFloat(sprintData.value.avgWorkRate - prevValue).toFixed(2)
    return diff > 0 ? `+${String(diff)}` : String(diff)
  })
  const numNewTicketChange = computed(() => {
    const prevValue = sprintData.value.prevSprint?.numNewTicket || 0
    const diff = sprintData.value.numNewTicket - prevValue
    return diff > 0 ? `+${String(diff)}` : String(diff)
  })
  const numPullRequestChange = computed(() => {
    const prevValue = sprintData.value.prevSprint?.numPullRequest || 0
    const diff = sprintData.value.numPullRequest - prevValue
    return diff > 0 ? `+${String(diff)}` : String(diff)
  })
  const numPrsMergedChange = computed(() => {
    const prevValue = sprintData.value.prevSprint?.numPrsMerged || 0
    const diff = sprintData.value.numPrsMerged - prevValue
    return diff > 0 ? `+${String(diff)}` : String(diff)
  })
  const numMessagesChange = computed(() => {
    const prevValue = sprintData.value.prevSprint?.numMessages || 0
    const diff = sprintData.value.numMessages - prevValue
    return diff > 0 ? `+${String(diff)}` : String(diff)
  })

  /**Transitions Graph Data*/
  const lineGraphChartOption = ref(JSON.parse(JSON.stringify(chartjsData.lineChart.options)))
  const barGraphChartOption = ref(JSON.parse(JSON.stringify(chartjsData.latestBarChart.options)))
  const numBacklogTransGraphData = ref({})
  const velocityTransGraphData = ref({})
  const numNewTicketTransGraphData = ref({})
  const numPullRequestTransGraphData = ref({})
  const numPrsMergedTransGraphData = ref({})
  const numMessagesTransGraphData = ref({})
  const unclosedTicketsData = ref({})

  watch(sprintData, (value, preValue) => {
    const {
      numBacklogTransitions,
      velocityTransitions,
      numNewTicketTransitions,
      numPullRequestTransitions,
      numPrsMergedTransitions,
      numMessagesTransitions,
      unclosedTickets,
    } = value

    numBacklogTransGraphData.value = makeGraphData(numBacklogTransitions)
    velocityTransGraphData.value = makeGraphData(velocityTransitions)
    numNewTicketTransGraphData.value = makeGraphData(numNewTicketTransitions)
    numPullRequestTransGraphData.value = makeGraphData(numPullRequestTransitions)
    numPrsMergedTransGraphData.value = makeGraphData(numPrsMergedTransitions)
    numMessagesTransGraphData.value = makeGraphData(numMessagesTransitions)
    unclosedTicketsData.value = unclosedTickets.map(t => {
      return {
        itemId: t.id,
        itemName: t.title,
        rate: moment(t.endDate).format('MM/DD/YYYY'),
      }
    })
  })

  const makeGraphData = transitions => {
    let values = transitions.map(v => parseFloat(v.avg).toFixed(2))
    let labels = transitions.map(v => moment(v.endDate).format('MM/DD'))
    let localChartData = JSON.parse(JSON.stringify(chartjsData.lineChart.data))
    localChartData.datasets[0].data = JSON.parse(JSON.stringify(values))
    localChartData.labels = JSON.parse(JSON.stringify(labels))
    return localChartData
  }

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
  }
}
