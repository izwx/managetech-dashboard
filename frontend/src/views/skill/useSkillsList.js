import store from '@/store'
import { ref, watch } from '@vue/composition-api'
import { mdiAccountOutline, mdiCogOutline, mdiDatabaseOutline, mdiDnsOutline, mdiPencilOutline } from '@mdi/js'

export default function useSkillsList() {
  const skillListTable = ref([])

  const tableColumns = [
    { text: 'Skill Name', value: 'skill_name' },
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

  const totalSkillListTable = ref(0)
  const loading = ref(false)
  const options = ref({
    sortBy: ['id'],
    sortDesc: [true],
    createrId: store.state.sessionManager.user.id,
  })
  const selectedRows = ref([])

  // fetch data
  const fetchSkills = () => {
    store
      .dispatch('app-skill/fetchSkills', {
        q: searchQuery.value,
        options: options.value,
      })
      .then(response => {
        const {
          skillMasters,
          meta: {
            pagination: { total: totalValue },
          },
        } = response.data

        skillListTable.value = JSON.parse(JSON.stringify(skillMasters))
        totalSkillListTable.value = totalValue

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
    fetchSkills()
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
    skillListTable,
    tableColumns,
    searchQuery,
    totalSkillListTable,
    loading,
    options,
    selectedRows,
    fetchSkills,
    resolveUserRoleVariant,
    resolveUserRoleIcon,
  }
}
