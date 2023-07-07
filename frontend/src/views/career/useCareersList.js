import store from '@/store'
import { ref, watch } from '@vue/composition-api'
import { mdiAccountOutline, mdiCogOutline, mdiDatabaseOutline, mdiDnsOutline, mdiPencilOutline } from '@mdi/js'

export default function useCareersList() {
  const careerListTable = ref([])

  const tableColumns = [
    { text: 'Developer Name', value: 'developer_name', sortable: false },
    { text: 'Start Month', value: 'start_month', sortable: false },
    { text: 'End Month', value: 'end_month', sortable: false },
    { text: 'Project Name', value: 'project_name', sortable: false },
    { text: 'Role', value: 'role' },

    {
      text: 'Actions',
      value: 'actions',
      align: 'right',
      sortable: false,
    },
  ]

  const searchQuery = ref('')

  const totalCareerListTable = ref(0)
  const loading = ref(false)
  const options = ref({
    sortBy: ['id'],
    sortDesc: [true],
  })
  const selectedRows = ref([])

  const userRole = store.state.sessionManager.user.role
  const userId = store.state.sessionManager.user.id
  const companyId = store.state.sessionManager.user.company_id

  // fetch data
  const fetchCareers = () => {
    store
      .dispatch('app-career/fetchCareers', {
        q: searchQuery.value,
        options: options.value,
        ...(userRole == 'projectManager') ? {companyId} : ((userRole == 'developer') ? {userId} : {})
      })
      .then(response => {
        const {
          developerCareers,
          meta: {
            pagination: { total: totalValue },
          },
        } = response.data

        careerListTable.value = JSON.parse(JSON.stringify(developerCareers))
        totalCareerListTable.value = totalValue

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
    fetchCareers()
  })

  // *===============================================---*
  // *--------- UI ---------------------------------------*
  // *===============================================---*

  const resolveUserRoleVariant = role => {
    if (role === 'manager') return 'primary'
    if (role === 'client') return 'warning'
    if (role === 'projectManager') return 'success'
    if (role === 'developer') return 'info'
    if (role === 'superAdmin') return 'error'

    return 'primary'
  }

  const resolveUserRoleIcon = role => {
    if (role === 'manager') return mdiAccountOutline
    if (role === 'client') return mdiCogOutline
    if (role === 'projectManager') return mdiDatabaseOutline
    if (role === 'developer') return mdiPencilOutline
    if (role === 'superAdmin') return mdiDnsOutline

    return mdiAccountOutline
  }

  return {
    careerListTable,
    tableColumns,
    searchQuery,
    totalCareerListTable,
    loading,
    options,
    selectedRows,
    fetchCareers,
    userRole,
    userId,
    companyId,
    resolveUserRoleVariant,
    resolveUserRoleIcon,
  }
}
