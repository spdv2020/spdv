<template>
  <div class="card shadow mb-4">
    <div v-if="selected === -1" class="card-header py-3">
      <h6 class="m-0 font-weight-bold text-primary">{{ name }}</h6>
    </div>
    <div v-else class="py-3 px-3 divider">
      <slot name="actions" :selected="getSelected()"></slot>
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table ref="table" class="table table-bordered table-hover" cellspacing="0">
          <!-- <thead>
            <tr>
              <th v-for="column in columns" :key="column.key" :class="{ numeric: ['numeric', 'money'].indexOf(column.type ?? '') !== -1 }">
                {{ column.label }}
              </th>
            </tr>
          </thead> -->
          <!-- <tbody>
            <tr v-for="entity in entities" :key="entity[entitiyKey]" @click="toggleSelected(entity[entitiyKey])" :class="{ 'table-active': isSelected(entity[entitiyKey]) }">
              <td v-for="column in columns" :key="`${entity[entitiyKey]}-${column.key}`" :class="{ numeric: ['numeric', 'money'].indexOf(column.type ?? '') !== -1 }">
                {{ format(entity[column.key], column.type) }}
              </td>
            </tr>
          </tbody> -->
        </table>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  .numeric {
    text-align: right
  }

  .table-hover tr {
    cursor: pointer;
  }

  .divider {
    border-bottom: 1px solid #e3e6f0;
  }
</style>

<script lang="ts">
import { defineComponent, PropType, ref, toRefs, onMounted, onBeforeMount, watch } from 'vue'

import type { Column } from '@/hooks/pagination'

import moment from 'moment'

export default defineComponent({
  name: 'DataTable',
  props: {
    name: {
      type: String,
      required: true
    },
    columns: {
      type: Array as PropType<Column[]>,
      required: true
    },
    entitiyKey: {
      type: String,
      required: true
    },
    entities: {
      type: Array as PropType<Record<string, string | undefined>[]>,
      required: true
    }
  },
  setup (props) {
    const table = ref<Element>()
    const { entities, entitiyKey } = toRefs(props)

    const selected = ref<string | number>(-1)

    let dTable: any = null

    function destroyTable () {
      const api = new window.$.fn.DataTable.Api(table.value)

      api.destroy()
    }

    function mountTable () {
      destroyTable()

      dTable = window.$(table.value).DataTable({
        select: 'single',
        data: props.entities,
        columns: props.columns.map(c => ({ data: c.key, title: c.label }))
      })

      window.$(table.value).on('click', 'tr', function () {
        // alert('opa')
      })
    }

    onMounted(() => {
      mountTable()
    })

    onBeforeMount((): void => {
      destroyTable()
    })

    watch(() => props.entities, (_): void => {
      mountTable()
    })

    function toggleSelected (key: string | undefined) {
      if (typeof key === 'undefined') {
        return
      }

      if (selected.value === key) {
        selected.value = -1
      } else {
        selected.value = key
      }
    }

    function isSelected (key: string | undefined): boolean {
      if (typeof key === 'undefined') {
        return false
      }

      return selected.value === key
    }

    function getSelected (): Record<string, string | undefined> | undefined {
      return entities.value.find(e => e[entitiyKey.value] === selected.value)
    }

    const format = (data: string | undefined, type: Column['type']): string | undefined => {
      if (typeof data === 'undefined') {
        return undefined
      }

      switch (type) {
        case 'date':
          return moment(data).format('DD/MM/YYYY')
        case 'datetime':
          return moment(data).format('DD/MM/YYYY HH:mm')
        case 'money':
          return Number(data).toFixed(2).replace(/\./, ',')
        default:
          return data
      }
    }

    return {
      format,

      selected,
      toggleSelected,
      isSelected,
      getSelected,

      table
    }
  }
})
</script>
