<template>
  <div>
    <AdminBody>
      <template v-slot:heading>
        <HeadingDefault name="Produtos">
          <template v-slot:right>
            <button class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm" @click="open()">
              <i class="fas fa-plus fa-sm text-white-50"></i> Adicionar
            </button>
          </template>
        </HeadingDefault>
      </template>

      <template v-slot:default>
        <!-- Content Row -->
        <div class="row">
          <div class="col-12">
            <!-- DataTales Example -->
            <div class="card shadow mb-4">
              <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Produtos</h6>
              </div>
              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-bordered" cellspacing="0">
                    <thead>
                      <tr>
                        <th>#</th>
                        <th>Nome</th>
                        <th>Preço (R$)</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-for="produto in produtos" :key="produto.id">
                        <td>{{ produto.id }}</td>
                        <td>{{ produto.nome }}</td>
                        <td>{{ produto.valor_unit }}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <div ref="modalRef" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
            <form class="user" @submit="onSubmit">
              <div class="modal-dialog" role="document">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title">Cadastro de produto</h5>
                    <button class="close" type="button" @click="close()" aria-label="Close">
                      <span aria-hidden="true">×</span>
                    </button>
                  </div>
                  <div class="modal-body">
                    <div class="form-group">
                      <label for="nome">Nome</label>
                      <input
                        type="text"
                        id="nome"
                        class="form-control"
                        autocomplete="off"
                        name="nome"
                        v-model="nome"
                        :class="{ 'is-invalid': !!errors.nome }"
                      />
                      <div class="invalid-feedback">
                        <small>{{ errors.nome || 'default' }}</small>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="valor_unit">Valor de venda (R$)</label>
                      <input
                        ref="inputRef"
                        type="text"
                        id="valor_unit"
                        class="form-control"
                        autocomplete="off"
                        name="valor_unit"
                        v-model="valor_unit"
                        :class="{ 'is-invalid': !!errors.valor_unit }"
                      />
                      <div class="invalid-feedback">
                        <small>{{ errors.valor_unit || 'default' }}</small>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="valor_unit">Código de Barras</label>
                      <input
                        ref="inputRef"
                        type="text"
                        id="codigo_barras"
                        class="form-control"
                        autocomplete="off"
                        name="codigo_barras"
                        v-model="codigo_barras"
                        :class="{ 'is-invalid': !!errors.codigo_barras }"
                      />
                      <div class="invalid-feedback">
                        <small>{{ errors.codigo_barras || 'default' }}</small>
                      </div>
                    </div>
                </div>
                <div class="modal-footer">
                  <button class="btn btn-link" type="button" @click="close()">Cancelar</button>
                  <button type="submit" class="btn btn-primary" href="login.html">Salvar</button>
                </div>
                </div>
              </div>
            </form>
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

import useFetchEntities from '@/hooks/fetchEntities'

import { Modal } from 'bootstrap'

import * as yup from 'yup'
import { useForm, useField } from 'vee-validate'

import { execute } from '@/api'

interface Produto {
  id: number;
  nome: string;
  valor_unit: number;
}

export default defineComponent({
  name: 'ProductList',
  components: {
    AdminBody,
    HeadingDefault
  },

  setup () {
    let modal: Modal | null = null
    const modalRef = ref<Element>()

    const { entities: produtos, fetchEntities: fetchProdutos } = useFetchEntities<Produto>('/produtos')

    const schema = yup.object({
      nome: yup.string().required(),
      valor_unit: yup.number().required(),
      codigo_barras: yup.string().max(13)
    })

    const { errors, handleSubmit, resetForm } = useForm({ validationSchema: schema })

    function open () {
      if (modal) {
        modal.show()
      }
    }

    function close () {
      if (modal) {
        modal.hide()
        resetForm()
      }
    }

    const { value: nome } = useField('nome')
    const { value: valor_unit } = useField('valor_unit')
    const { value: codigo_barras } = useField('codigo_barras')

    const onSubmit = handleSubmit(async ({ nome, valor_unit, codigo_barras }) => {
      await execute('POST', '/produtos', {
        nome,
        valor_unit,
        codigo_barras
      })

      close()
      fetchProdutos()
    })

    onMounted(() => {
      modal = new Modal(modalRef.value as Element, {
        backdrop: 'static'
      })

      fetchProdutos()
    })

    return {
      modalRef,
      open,
      close,

      produtos,

      errors,
      nome,
      valor_unit,
      codigo_barras,
      onSubmit
    }
  }
})
</script>
