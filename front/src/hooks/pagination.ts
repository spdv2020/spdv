import { reactive, toRefs } from 'vue'

import useFetchEntities from './fetchEntities'

export interface Column {
  key: string;
  label: string;
  type?: 'string' | 'numeric' | 'date' | 'datetime' | 'money';
}

export interface State {
  columns: Column[];
  selected: string[];
}

export default function usePagination (path: string, columns: Column[]) {
  const state = reactive<State>({
    columns: columns,
    selected: []
  })

  const { entities, fetchEntities } = useFetchEntities<Record<string, string | undefined>>(path)

  function toggleSelect (key: string) {
    const index = state.selected.indexOf(key)
    if (index === -1) {
      state.selected.push(key)
    } else {
      state.selected.splice(index, 1)
    }
  }

  return {
    entities,
    fetchEntities,

    toggleSelect,

    ...toRefs(state)
  }
}
