import { ref, Ref } from 'vue'

import { execute } from '@/api'

export default function useFetchEntities<T extends object> (path: string) {
  const error = ref('')
  const loading = ref(false)

  const entities = ref([]) as Ref<T[]>

  const fetchEntities = async () => {
    loading.value = true

    try {
      const data = await execute('GET', path) as T[]

      entities.value = data

      loading.value = false
    } catch (e) {
      console.error(e)
      error.value = e.message
    }
  }

  return {
    error,
    loading,

    entities,

    fetchEntities
  }
}
