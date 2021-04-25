<template>
  <div>
    <AdminBody>
      <template v-slot:heading>
        <HeadingDefault name="Subcategorias">
          <template v-slot:right>
            <button class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm" @click="open(undefined)">
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
            <DataTable
              name="Subcategorias"
              :columns="columns"

              entitiyKey="id"
              :entities="entities"
            >
              <template v-slot:actions="{ selected }">
                <div class="d-flex justify-content-end">
                  <button type="button" class="btn btn-secondary btn-sm mr-1" @click="open(selected)">Editar</button>
                  <button type="button" class="btn btn-danger btn-sm" @click="openExcluir(selected)">Excluir</button>
                </div>
              </template>
            </DataTable>
          </div>

          <div ref="modalExcluirRef" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title">Excluir subcategoria</h5>
                  <button class="close" type="button" @click="close()" aria-label="Close">
                    <span aria-hidden="true">×</span>
                  </button>
                </div>
                <div class="modal-body">
                  <h6 v-if="!!selected">Tem certeza que deseja excluir a subcategoria "{{ selected.nome }}"?</h6>
                </div>
                <div class="modal-footer">
                  <button class="btn btn-link" type="button" @click="close()">Cancelar</button>
                  <button type="button" class="btn btn-primary" @click="excluir()">Excluir</button>
                </div>
              </div>
            </div>
          </div>

          <div ref="modalRef" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
            <form class="user" @submit="onSubmit">
              <div class="modal-dialog" role="document">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title">{{ selected === null ? 'Cadastrar marca' : 'Editar marca' }}</h5>
                    <button class="close" type="button" @click="close()" aria-label="Close">
                      <span aria-hidden="true">×</span>
                    </button>
                  </div>
                  <div class="modal-body">
                    <div class="form-group">
                      <label for="email">Nome</label>
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
                      <label for="categoria_id">Categoria</label>
                      <select
                        id="categoria_id"
                        class="form-control"
                        autocomplete="off"
                        name="categoria_id"
                        v-model="categoria_id"
                        :class="{ 'is-invalid': !!errors.categoria_id }"
                        style="width: 100%; display: none;"
                      >
                        <option value="">Selecione uma marca</option>
                        <option v-for="categoria in categorias" :value="categoria.id" :key="categoria.id">{{ categoria.nome }}</option>
                      </select>
                      <div class="invalid-feedback">
                        <small>{{ errors.categoria_id || 'default' }}</small>
                      </div>
                    </div>
                </div>
                <div class="modal-footer">
                  <button class="btn btn-link" type="button" @click="close()">Cancelar</button>
                  <button type="submit" class="btn btn-primary">Salvar</button>
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
import DataTable from '@/components/DataTable/DataTable.vue'

import usePagination from '@/hooks/pagination'
import useFetchEntities from '@/hooks/fetchEntities'

import { Modal } from 'bootstrap'

import * as yup from 'yup'
import { useForm, useField } from 'vee-validate'

import { execute } from '@/api'

import $ from 'jquery'
import 'select2'

interface ProdutoMarca {
  id: number;
  nome: string;
  data_atualizacao: string;
  data_criacao: string;
}

export default defineComponent({
  name: 'ProductList',
  components: {
    AdminBody,
    HeadingDefault,
    DataTable
  },

  setup () {
    let modal: Modal | null = null
    const modalRef = ref<Element>()

    let modalExcluir: Modal | null = null
    const modalExcluirRef = ref<Element>()

    const schema = yup.object({
      nome: yup.string().min(3).required(),
      categoria_id: yup.string().required()
    })

    const { errors, handleSubmit, resetForm, setFieldError } = useForm({ validationSchema: schema })

    const selected = ref<any>(null)
    const { value: nome } = useField('nome')
    const { value: categoria_id } = useField('categoria_id')

    function open (item: Record<string, string | undefined> | undefined) {
      $('[name=categoria_id]').select2({
        theme: 'bootstrap4'
      }).on('select2:select', function (e) {
        const v = Number(e.params.data.id)
        if (v === 0) {
          categoria_id.value = ''
        } else {
          categoria_id.value = v
        }
      })

      if (typeof item !== 'undefined') {
        selected.value = item
        nome.value = item.nome as string
        categoria_id.value = item.categoria_id as string ?? ''
        $('[name=categoria_id]').val(categoria_id.value as string).trigger('change')
      }

      if (modal) {
        modal.show()
      }
    }

    function openExcluir (item: Record<string, string | undefined> | undefined) {
      if (typeof item !== 'undefined') {
        selected.value = item
      }

      if (modalExcluir) {
        modalExcluir.show()
      }
    }

    function close () {
      if (modal) {
        modal.hide()
        resetForm()
      }
      if (modalExcluir) {
        modalExcluir.hide()
      }

      $('[name=categoria_id]').select2('destroy')

      selected.value = null
    }

    const { entities: categorias, fetchEntities: fetchCategorias } = useFetchEntities('/produtos/categorias')

    const { entities, fetchEntities, columns } = usePagination('/produtos/subcategorias', [{
      key: 'id',
      label: '#',
      type: 'numeric'
    }, {
      key: 'nome',
      label: 'Nome'
    }, {
      key: 'categoria',
      label: 'Categoria'
    }, {
      key: 'data_atualizacao',
      label: 'Atualizado em',
      type: 'datetime'
    }, {
      key: 'data_criacao',
      label: 'Criado em',
      type: 'datetime'
    }])

    const onSubmit = handleSubmit(async ({ nome, categoria_id }) => {
      try {
        if (!selected.value?.id) {
          await execute('POST', '/produtos/subcategorias', {
            nome,
            categoria_id
          })
        } else {
          await execute('PATCH', '/produtos/subcategorias', {
            id: selected.value?.id,
            nome,
            categoria_id
          })
        }

        close()
        fetchEntities()
      } catch (e) {
        setFieldError('nome', e.message)
      }
    })

    const excluir = async () => {
      try {
        await execute('DELETE', '/produtos/subcategorias', {
          id: selected.value.id
        })

        fetchEntities()
        close()
      } catch (e) {
      }
    }

    onMounted(() => {
      modal = new Modal(modalRef.value as Element, {
        backdrop: 'static',
        keyboard: false
      })
      modalExcluir = new Modal(modalExcluirRef.value as Element, {
        backdrop: 'static',
        keyboard: false
      })

      fetchEntities()
      fetchCategorias()
    })

    return {
      modalRef,
      modalExcluirRef,
      open,
      close,
      columns,

      entities,
      openExcluir,
      selected,

      errors,
      nome,
      excluir,
      onSubmit,

      categorias,
      categoria_id
    }
  }
})
</script>
