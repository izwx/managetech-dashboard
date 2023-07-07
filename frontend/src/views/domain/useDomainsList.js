import store from '@/store'
import { ref, watch } from '@vue/composition-api'
import { mdiAccountOutline, mdiCogOutline, mdiDatabaseOutline, mdiDnsOutline, mdiPencilOutline } from '@mdi/js'

export default function useDomainsList() {
  const domainListTable = ref([])

  const tableColumns = [
    { text: 'Domain Name', value: 'domain_name' },
    { text: 'Project Name', value: 'project_name', sortable: false },
    { text: 'Creater', value: 'creater', sortable: false },
    {
      text: 'Actions',
      value: 'actions',
      align: 'right',
      sortable: false,
    },
  ]

  const searchQuery = ref('')

  const totalDomainListTable = ref(0)
  const loading = ref(false)
  const options = ref({
    sortBy: ['id'],
    sortDesc: [true],
    createrId: store.state.sessionManager.user.id,
  })
  const selectedRows = ref([])

  // fetch data
  const fetchDomains = () => {
    store
      .dispatch('app-domain/fetchDomains', {
        q: searchQuery.value,
        options: options.value,
      })
      .then(response => {
        const {
          domainMasters,
          meta: {
            pagination: { total: totalValue },
          },
        } = response.data

        domainListTable.value = [...domainMasters]
        totalDomainListTable.value = totalValue

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
    fetchDomains()
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
    domainListTable,
    tableColumns,
    searchQuery,
    totalDomainListTable,
    loading,
    options,
    selectedRows,
    fetchDomains,
    resolveUserRoleVariant,
    resolveUserRoleIcon,
  }
}
