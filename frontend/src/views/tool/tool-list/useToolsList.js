import store from '@/store'
import { ref, watch } from '@vue/composition-api'

export default function useToolsList() {
  const toolListTable = ref([])

  const tableColumns = [
    { text: 'Tool Name', value: 'tool_name' },
    { text: 'Token Guide', value: 'token_guide' },
    { text: 'Target Guide', value: 'target_guide' },
    { text: 'Payload Guide', value: 'payload_guide' },
    { text: 'Account Name Guide', value: 'account_name_guide' },
    {
      text: 'Actions',
      value: 'actions',
      align: 'right',
      sortable: false,
    },
  ]

  const searchQuery = ref('')

  const totalToolListTable = ref(0)
  const loading = ref(false)
  const options = ref({
    sortBy: ['id'],
    sortDesc: [true],
  })
  const selectedRows = ref([])

  // fetch data
  const fetchTools = () => {
    store
      .dispatch('app-tool/fetchTools', {
        q: searchQuery.value,
        options: options.value,
      })
      .then(response => {
        const {
          toolMasters,
          meta: {
            pagination: { total: totalValue },
          },
        } = response.data

        toolListTable.value = [...toolMasters]
        totalToolListTable.value = totalValue

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
    fetchTools()
  })

  return {
    toolListTable,
    tableColumns,
    searchQuery,
    totalToolListTable,
    loading,
    options,
    selectedRows,
    fetchTools,
  }
}
