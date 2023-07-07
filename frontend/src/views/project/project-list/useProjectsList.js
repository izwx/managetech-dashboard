import store from '@/store'
import { ref, watch } from '@vue/composition-api'

export default function useProjectsList() {
  const projectListTable = ref([])

  const tableColumns = [
    { text: 'Project Name', value: 'project_name' },
    { text: 'Company Name', value: 'company_name' },
    { text: 'Project Phase', value: 'project_phase' },
    { text: 'Progress Rate', value: 'progress_rate', sortable: false },
    { text: 'Project Status', value: 'project_status', sortable: false },
    { text: '', value: 'actions', align: 'right', sortable: false },
  ]

  const resolveProgressVariant = progrss => {
    if (progrss <= 25) return 'error'
    if (progrss > 25 && progrss <= 50) return 'warning'
    if (progrss > 50 && progrss <= 75) return 'primary'
    if (progrss > 75 && progrss <= 100) return 'success'

    return 'secondary'
  }

  const searchQuery = ref('')

  const totalProjectListTable = ref(0)
  const loading = ref(false)
  const options = ref({
    sortBy: ['id'],
    sortDesc: [true],
  })
  const selectedRows = ref([])

  const userRole = store.state.sessionManager.user.role
  const userCompanyId = store.state.sessionManager.user.company_id

  // fetch data
  const fetchProjects = () => {
    store
      .dispatch('app-project/fetchProjects', {
        q: searchQuery.value,
        options: options.value,
        clientCompanyId: userRole == 'client' && userCompanyId ? userCompanyId : null,
        companyId: (userRole == 'developer' || userRole == 'projectManager') && userCompanyId ? userCompanyId : null,
      })
      .then(response => {
        const {
          projects,
          meta: {
            pagination: { total: totalValue },
          },
        } = response.data

        projectListTable.value = [...projects]
        totalProjectListTable.value = totalValue

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
    fetchProjects()
  })

  return {
    projectListTable,
    tableColumns,
    resolveProgressVariant,
    searchQuery,
    totalProjectListTable,
    loading,
    options,
    selectedRows,
    fetchProjects,
  }
}
