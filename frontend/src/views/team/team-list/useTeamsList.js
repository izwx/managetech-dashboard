import store from '@/store'
import {
  mdiAccountCheckOutline,
  mdiAccountOutline,
  mdiAccountPlusOutline,
  mdiAccountRemoveOutline,
  mdiCogOutline,
  mdiDatabaseOutline,
  mdiDnsOutline,
  mdiPencilOutline,
} from '@mdi/js'
import { ref, watch } from '@vue/composition-api'

export default function useTeamsList() {
  const teamListTable = ref([])

  const tableColumns = [
    { text: 'Team Name', value: 'team_name' },
    { text: 'Members Count', value: 'num_members' },
    { text: 'Average Velocity', value: 'avg_velocity' },
    { text: 'Average Work Rate', value: 'avg_work_rate' },
    { text: 'Number of Documents', value: 'num_documents' },
    {
      text: 'Actions',
      value: 'actions',
      align: 'right',
      sortable: false,
    },
  ]

  const searchQuery = ref('')

  const totalTeamListTable = ref(0)
  const loading = ref(false)
  const options = ref({
    sortBy: ['id'],
    sortDesc: [true],
  })
  const selectedRows = ref([])

  const userRole = store.state.sessionManager.user.role
  const userCompanyId = store.state.sessionManager.user.company_id

  // fetch data
  const fetchTeams = () => {
    store
      .dispatch('app-team/fetchTeams', {
        q: searchQuery.value,
        options: options.value,
        companyId: (userRole == 'developer' || userRole == 'projectManager') && userCompanyId ? userCompanyId : null,
      })
      .then(response => {
        const {
          teams,
          meta: {
            pagination: { total: totalValue },
          },
        } = response.data

        teamListTable.value = [...teams]
        totalTeamListTable.value = totalValue

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
    fetchTeams()
  })

  // *===============================================---*
  // *--------- UI ---------------------------------------*
  // *===============================================---*

  const resolveTeamRoleVariant = role => {
    if (role === 'subscriber') return 'primary'
    if (role === 'author') return 'warning'
    if (role === 'maintainer') return 'success'
    if (role === 'editor') return 'info'
    if (role === 'admin') return 'error'

    return 'primary'
  }

  const resolveTeamRoleIcon = role => {
    if (role === 'subscriber') return mdiAccountOutline
    if (role === 'author') return mdiCogOutline
    if (role === 'maintainer') return mdiDatabaseOutline
    if (role === 'editor') return mdiPencilOutline
    if (role === 'admin') return mdiDnsOutline

    return mdiAccountOutline
  }

  const resolveTeamStatusVariant = status => {
    if (status === 'pending') return 'warning'
    if (status === 'active') return 'success'
    if (status === 'inactive') return 'secondary'

    return 'primary'
  }

  const resolveTeamTotalIcon = total => {
    if (total === 'Total Teams') return { icon: mdiAccountOutline, color: 'primary' }
    if (total === 'Paid Teams') return { icon: mdiAccountPlusOutline, color: 'error' }
    if (total === 'Active Teams') return { icon: mdiAccountCheckOutline, color: 'success' }
    if (total === 'Pending Teams') return { icon: mdiAccountRemoveOutline, color: 'warning' }

    return { icon: mdiAccountOutline, color: 'primary' }
  }

  return {
    teamListTable,
    tableColumns,
    searchQuery,
    totalTeamListTable,
    loading,
    options,
    selectedRows,
    fetchTeams,
    resolveTeamRoleVariant,
    resolveTeamRoleIcon,
    resolveTeamStatusVariant,
    resolveTeamTotalIcon,
  }
}
