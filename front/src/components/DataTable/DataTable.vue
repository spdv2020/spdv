<template>
  <div class="card shadow mb-4">
    <div v-if="selected === -1" class="card-header py-3">
      <h6 class="m-0 font-weight-bold text-primary">{{ name }}</h6>
    </div>
    <div v-else class="py-3 px-3 divider">
      <slot name="actions" :selected="getSelected()"></slot>
    </div>
    <div class="card-body">
      <div class="table">
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

<style lang="scss">
  .dt-table-numeric {
    text-align: right
  }
</style>

<script lang="ts">
import { defineComponent, PropType, ref, toRefs, onMounted, onBeforeMount, watch } from 'vue'

import type { Column } from '@/hooks/pagination'

import moment from 'moment'

import lang from './lang.json'

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

    function onClick (this: any) {
      const api = new window.$.fn.DataTable.Api(table.value)
      const data = api.row(this).data()

      window.$('tr', table.value).not(this).removeClass('table-active')
      window.$(this).toggleClass('table-active')

      toggleSelected(data[props.entitiyKey])
    }

    function destroyTable () {
      window.$('tbody', table.value).off('click', 'tr', onClick)
      const api = new window.$.fn.DataTable.Api(table.value)

      api.state.save()

      api.destroy()
    }

    function mountTable () {
      destroyTable()

      dTable = window.$(table.value).DataTable({
        stateSave: true,
        data: props.entities.map((entity) => {
          return props.columns.reduce((acc, column) => {
            let value = entity[column.key]

            if (typeof value === 'undefined') {
              value = undefined
            }

            switch (column.type) {
              case 'date':
                value = moment(value).format('DD/MM/YYYY')
                break
              case 'datetime':
                value = moment(value).format('DD/MM/YYYY HH:mm')
                break
              case 'money':
                value = Number(value).toFixed(2).replace(/\./, ',')
                break
            }

            return {
              ...acc,
              [entitiyKey.value]: entity[entitiyKey.value],
              [column.key]: value
            }
          }, {})
        }),
        columns: props.columns.map(c => ({
          data: c.key,
          title: c.label,
          ...(['numeric', 'money'].indexOf(c.type ?? '') !== -1 ? { className: 'dt-table-numeric' } : {}),
          width: c.width
        })),
        language: lang
      })

      window.$('tbody', table.value).on('click', 'tr', onClick)
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
