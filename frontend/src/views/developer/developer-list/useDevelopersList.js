import store from '@/store'
import { ref, watch } from '@vue/composition-api'

export default function useDevelopersList() {
  const developerListTable = ref([])

  const tableColumns = [
    { text: 'Developer Name', value: 'developer_name' },
    { text: 'Teams', value: 'teams' },
    { text: 'Average Velocity', value: 'avg_velocity' },
    { text: 'Average Work Rate', value: 'avg_work_rate' },
    { text: 'Number of Documents', value: 'num_documents' },
    { text: 'Average Lead Time', value: 'avg_lead_time' },
    { text: 'Average Reviews', value: 'avg_reviews' },
    { text: 'Average Review Hours', value: 'avg_review_hours' },
    {
      text: 'Actions',
      value: 'actions',
      align: 'right',
      sortable: false,
    },
  ]

  const searchQuery = ref('')

  const totalDeveloperListTable = ref(0)
  const loading = ref(false)
  const options = ref({
    sortBy: ['id'],
    sortDesc: [true],
  })
  const selectedRows = ref([])

  const userRole = store.state.sessionManager.user.role
  const userCompanyId = store.state.sessionManager.user.company_id
  // fetch data
  const fetchDevelopers = () => {
    store
      .dispatch('app-developer/fetchDevelopers', {
        q: searchQuery.value,
        options: options.value,
        companyId: (userRole == 'developer' || userRole == 'projectManager') && userCompanyId ? userCompanyId : null,
      })
      .then(response => {
        const {
          developers,
          meta: {
            pagination: { total: totalValue },
          },
        } = response.data

        developerListTable.value = [...developers]
        totalDeveloperListTable.value = totalValue

        // remove loading state
        loading.value = false
      })
      .catch(error => {
        console.log(error)
      })
  }

  watch([searchQuery, options], () => {
    loading.value = true
    selectedRows.value = []
    fetchDevelopers()
  })

  return {
    developerListTable,
    userCompanyId,
    tableColumns,
    searchQuery,
    totalDeveloperListTable,
    loading,
    options,
    selectedRows,
    fetchDevelopers,
  }
}
