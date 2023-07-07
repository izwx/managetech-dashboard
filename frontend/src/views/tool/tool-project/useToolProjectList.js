import store from '@/store'
import { ref, watch } from '@vue/composition-api'

export default function useToolProjectsList() {
  const projectListTable = ref([])

  const tableColumns = [{ text: 'Project Name', value: 'project_name' }]

  const searchQuery = ref('')

  const totalProjectListTable = ref(0)
  const loading = ref(false)
  const options = ref({
    sortBy: ['id'],
    sortDesc: [true],
  })

  const userRole = store.state.sessionManager.user.role
  const userCompanyId = store.state.sessionManager.user.company_id
  // fetch data
  const fetchProjects = () => {
    store
      .dispatch('app-project/fetchProjects', {
        q: searchQuery.value,
        options: options.value,
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
    fetchProjects()
  })

  return {
    projectListTable,
    tableColumns,
    searchQuery,
    totalProjectListTable,
    loading,
    options,
    fetchProjects,
  }
}
