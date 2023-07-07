import store from '@/store'
import { ref, watch } from '@vue/composition-api'

export default function useProfile() {
  const profileData = ref({})
  const fetchProfile = () => {
    store.dispatch('app-profile/fetchProfile').then(response => {
      const { user } = response.data
      profileData.value = user
    })
  }

  return {
    profileData,
    fetchProfile,
  }
}
