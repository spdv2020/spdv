<template>
  <div>
    <AdminBody>
      <template v-slot:heading>
        <HeadingDefault name="Vendas">
          <template v-slot:right>
            <!-- <button class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm" @click="open(undefined)">
              <i class="fas fa-plus fa-sm text-white-50"></i> Adicionar
            </button> -->
          </template>
        </HeadingDefault>
      </template>

      <template v-slot:default>
        <!-- Content Row -->
        <div class="row">
          <div class="col-12">
            <!-- DataTales Example -->
            <DataTable
              name="Vendas"
              :columns="columns"

              entitiyKey="id"
              :entities="entities"
            >
            </DataTable>
          </div>
        </div>
      </template>
    </AdminBody>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref } from 'vue'

import AdminBody from '@/components/admin/Body.vue'
import HeadingDefault from '@/components/admin/HeadingDefault.vue'
import DataTable from '@/components/DataTable/DataTable.vue'

import usePagination from '@/hooks/pagination'

export default defineComponent({
  name: 'RelatorioVendas',
  components: {
    AdminBody,
    HeadingDefault,
    DataTable
  },

  setup () {
    const { entities, fetchEntities, columns } = usePagination('/vendas', [{
      key: 'status',
      label: 'Status',
      type: 'string',
      width: '10%'
    }, {
      key: 'valor_subtotal',
      label: 'Subtotal (R$)',
      type: 'money',
      width: '10%'
    }, {
      key: 'valor_desconto',
      label: 'Desconto (R$)',
      type: 'money',
      width: '10%'
    }, {
      key: 'valor_total',
      label: 'Total (R$)',
      type: 'money',
      width: '10%'
    }, {
      key: 'valor_recebido',
      label: 'Recebido (R$)',
      type: 'money',
      width: '10%'
    }, {
      key: 'valor_troco',
      label: 'Troco (R$)',
      type: 'money',
      width: '10%'
    }, {
      key: 'metodo_pagamento',
      label: 'Forma de pagamento',
      type: 'string',
      width: '15%'
    }, {
      key: 'qtd_produtos',
      label: 'Nº itens',
      type: 'numeric',
      width: '10%'
    }])

    onMounted(() => {
      fetchEntities()
    })

    return {
      columns,

      entities
    }
  }
})
</script>
