import store from '@/store'
import { ref, watch } from '@vue/composition-api'

export default function useLogsList() {
  const logListTable = ref([])

  const tableColumns = [
    { text: 'Company Name', value: 'company_name' },
    { text: 'Project Name', value: 'project_name' },
    { text: 'Module', value: 'module' },
    { text: 'Type', value: 'batch_type' },
    { text: 'Content', value: 'content' },
    { text: 'Start Time', value: 'start_datetime' },
    { text: 'End Time', value: 'end_datetime' },
    { text: 'Actions', value: 'actions', align: 'right', sortable: false },
  ]

  const searchQuery = ref('')

  const totalLogListTable = ref(0)
  const loading = ref(false)
  const options = ref({
    sortBy: ['id'],
    sortDesc: [true],
  })

  const userRole = store.state.sessionManager.user.role
  const userCompanyId = store.state.sessionManager.user.company_id

  // fetch data
  const fetchLogs = () => {
    store
      .dispatch('app-log/fetchLogs', {
        q: searchQuery.value,
        options: options.value,
        companyId: (userRole == 'developer' || userRole == 'projectManager') && userCompanyId ? userCompanyId : null,
      })
      .then(response => {
        const {
          batchLogs,
          meta: {
            pagination: { total: totalValue },
          },
        } = response.data

        logListTable.value = JSON.parse(JSON.stringify(batchLogs))
        totalLogListTable.value = totalValue

        // remove loading state
        loading.value = false
      })
      .catch(error => {
        console.log(error)
      })
  }

  watch([searchQuery, options], () => {
    loading.value = true
    fetchLogs()
  })

  return {
    logListTable,
    tableColumns,
    totalLogListTable,
    loading,
    options,
    searchQuery,
    fetchLogs,
  }
}
