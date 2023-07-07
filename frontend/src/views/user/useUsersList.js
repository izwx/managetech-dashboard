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

export default function useUsersList() {
  const userListTable = ref([])

  const tableColumns = [
    { text: 'User', value: 'fullName' },
    { text: 'Email', value: 'email' },
    { text: 'Role', value: 'role', sortable: false },
    { text: 'Company Name', value: 'companyName', sortable: false },
    { text: 'Status', value: 'status', sortable: false },
    { text: 'Last Login', value: 'lastSignInAt', sortable: false },
    { text: 'Actions', value: 'actions', align: 'center', sortable: false },
  ]

  const searchQuery = ref('')
  const roleFilter = ref(null)
  const planFilter = ref(null)
  const statusFilter = ref(null)
  const totalUserListTable = ref(0)
  const loading = ref(false)
  const options = ref({
    sortBy: ['id'],
    sortDesc: [true],
  })
  const userTotalLocal = ref([])
  const selectedRows = ref([])

  // fetch data
  const fetchUsers = () => {
    store
      .dispatch('app-user/fetchUsers', {
        q: searchQuery.value,
        options: options.value,
        status: statusFilter.value,
        role: roleFilter.value,
        plan: planFilter.value,
      })
      .then(response => {
        const { users, meta } = response.data

        userListTable.value = [...users]
        totalUserListTable.value = meta.pagination.total
        userTotalLocal.value = [
          { title: 'Total Users', value: 'total_users', total: meta.totals.totalUsers },
          { title: 'Pending Users', value: 'pending_users', total: meta.totals.pendingUsers },
          { title: 'Active Users', value: 'active_users', total: meta.totals.activeUsers },
          { title: 'Inactive Users', value: 'inactive_users', total: meta.totals.inactiveUsers },
        ]

        // remove loading state
        loading.value = false
      })
      .catch(error => {
        console.log(error)
      })
  }

  watch([searchQuery, roleFilter, planFilter, statusFilter, options], () => {
    loading.value = true
    selectedRows.value = []
    fetchUsers()
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

  const resolveUserStatusVariant = status => {
    if (status === 'pending') return 'warning'
    if (status === 'active') return 'success'
    if (status === 'inactive') return 'secondary'

    return 'primary'
  }

  const resolveUserTotalIcon = total => {
    if (total === 'total_users') return { icon: mdiAccountOutline, color: 'primary' }
    if (total === 'pending_users') return { icon: mdiAccountPlusOutline, color: 'error' }
    if (total === 'active_users') return { icon: mdiAccountCheckOutline, color: 'success' }
    if (total === 'inactive_users') return { icon: mdiAccountRemoveOutline, color: 'warning' }

    return { icon: mdiAccountOutline, color: 'primary' }
  }

  return {
    userListTable,
    tableColumns,
    searchQuery,
    roleFilter,
    planFilter,
    statusFilter,
    totalUserListTable,
    loading,
    options,
    userTotalLocal,
    selectedRows,
    fetchUsers,
    resolveUserRoleVariant,
    resolveUserRoleIcon,
    resolveUserStatusVariant,
    resolveUserTotalIcon,
  }
}
