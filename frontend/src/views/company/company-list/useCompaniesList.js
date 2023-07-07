import store from '@/store'
import { ref, watch } from '@vue/composition-api'

export default function useCompaniesList() {
  const companyListTable = ref([])

  const tableColumns = [
    { text: 'Company Name', value: 'company_name' },
    {
      text: 'Actions',
      value: 'actions',
      align: 'right',
      sortable: false,
    },
  ]

  const searchQuery = ref('')

  const totalCompanyListTable = ref(0)
  const loading = ref(false)
  const options = ref({
    sortBy: ['id'],
    sortDesc: [true],
  })
  const selectedRows = ref([])

  // fetch data
  const fetchCompanies = () => {
    store
      .dispatch('app-company/fetchCompanies', {
        q: searchQuery.value,
        options: options.value,
      })
      .then(response => {
        const {
          companies,
          meta: {
            pagination: { total: totalValue },
          },
        } = response.data

        companyListTable.value = [...companies]
        totalCompanyListTable.value = totalValue

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
    fetchCompanies()
  })

  return {
    companyListTable,
    tableColumns,
    searchQuery,
    totalCompanyListTable,
    loading,
    options,
    selectedRows,
    fetchCompanies,
  }
}
