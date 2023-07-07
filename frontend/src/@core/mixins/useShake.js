import { ref } from '@vue/composition-api'

export default function useShake() {
  const shake = ref(false)

  const doShake = () => {
    shake.value = true
    setTimeout(() => {
      shake.value = false;
    }, 820);
  }

  return {
    shake,
    doShake,
  }
}