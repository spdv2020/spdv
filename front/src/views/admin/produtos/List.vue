<template>
  <div>
    <AdminBody>
      <template v-slot:heading>
        <HeadingDefault name="Produtos">
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
              name="Produtos"
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
                  <h5 class="modal-title">Excluir produto</h5>
                  <button class="close" type="button" @click="close()" aria-label="Close">
                    <span aria-hidden="true">×</span>
                  </button>
                </div>
                <div class="modal-body">
                  <h6 v-if="!!selected">Tem certeza que deseja excluir o produto "{{ selected.nome }}"?</h6>
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
                    <h5 class="modal-title">{{ selected === null ? 'Cadastrar produto' : 'Editar produto' }}</h5>
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
                        ref="valorUnitRef"
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
                    <div class="form-group">
                      <label for="valor_unit">Categoria / Subcategoria</label>
                      <select
                        id="subcategoria_id"
                        class="form-control"
                        autocomplete="off"
                        name="subcategoria_id"
                        v-model="subcategoria_id"
                        :class="{ 'is-invalid': !!errors.subcategoria_id }"
                        style="width: 100%"
                      >
                        <option value="">Selecione uma subcategoria</option>
                        <option v-for="subcategoria in subcategorias" :value="subcategoria.id" :key="subcategoria.id">{{ `${subcategoria.categoria} / ${subcategoria.nome}` }}</option>
                      </select>
                      <div class="invalid-feedback">
                        <small>{{ errors.subcategoria_id || 'default' }}</small>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="valor_unit">Marca <small>(Opcional)</small></label>
                      <select
                        id="marca_id"
                        class="form-control"
                        autocomplete="off"
                        name="marca_id"
                        v-model="marca_id"
                        :class="{ 'is-invalid': !!errors.marca_id }"
                        style="width: 100%"
                      >
                        <option value="">Selecione uma marca</option>
                        <option v-for="marca in marcas" :value="marca.id" :key="marca.id">{{ marca.nome }}</option>
                      </select>
                      <div class="invalid-feedback">
                        <small>{{ errors.marca_id || 'default' }}</small>
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

import Barcoder from 'barcoder'

import InputMask from 'inputmask'

interface Produto {
  id: number;
  nome: string;
  valor_unit: number;
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

    const valorUnitRef = ref<Element>()

    const schema = yup.object({
      nome: yup.string().required(),
      valor_unit: yup.number().min(0).required(),
      codigo_barras: yup.string().max(13).required().test('ean', 'O código de barras deve ser valido', function (value) {
        return Barcoder.validate(value)
      }),
      marca_id: yup.string(),
      subcategoria_id: yup.string().required()
    })

    const { errors, handleSubmit, resetForm, setFieldError } = useForm({ validationSchema: schema })

    const selected = ref<any>(null)
    const { value: nome } = useField('nome')
    const { value: valor_unit } = useField('valor_unit')
    const { value: codigo_barras } = useField('codigo_barras')
    const { value: marca_id } = useField('marca_id')
    const { value: subcategoria_id } = useField('subcategoria_id')

    valor_unit.value = '0.00'

    function open (item: Record<string, string | undefined> | undefined) {
      $('[name=marca_id]').select2({
        theme: 'bootstrap4'
      }).on('select2:select', function (e) {
        const v = Number(e.params.data.id)
        if (v === 0) {
          marca_id.value = ''
        } else {
          marca_id.value = v
        }
      })

      $('[name=subcategoria_id]').select2({
        theme: 'bootstrap4'
      }).on('select2:select', function (e) {
        const v = Number(e.params.data.id)
        if (v === 0) {
          subcategoria_id.value = ''
        } else {
          subcategoria_id.value = v
        }
      })

      if (typeof item !== 'undefined') {
        selected.value = item
        nome.value = item.nome as string
        valor_unit.value = Number(item.valor_unit as string).toFixed(2)
        codigo_barras.value = item.codigo_barras as string ?? ''
        marca_id.value = item.marca_id as string ?? ''
        subcategoria_id.value = item.subcategoria_id as string ?? ''
        $('[name=marca_id]').val(marca_id.value as string).trigger('change')
        $('[name=subcategoria_id]').val(subcategoria_id.value as string).trigger('change')
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

      $('[name=marca_id]').select2('destroy')
      $('[name=subcategoria_id]').select2('destroy')

      selected.value = null
    }

    const { entities: marcas, fetchEntities: fetchMarcas } = useFetchEntities('/produtos/marcas')
    const { entities: subcategorias, fetchEntities: fetchSubcategorias } = useFetchEntities('/produtos/subcategorias')

    const { entities, fetchEntities, columns } = usePagination('/produtos', [{
      key: 'id',
      label: '#',
      type: 'numeric',
      width: '10%'
    }, {
      key: 'nome',
      label: 'Nome',
      width: '25%'
    }, {
      key: 'subcategoria',
      label: 'Subcategoria',
      width: '10%'
    }, {
      key: 'codigo_barras',
      label: 'Código de barras',
      width: '15%'
    }, {
      key: 'valor_unit',
      label: 'Preço (R$)',
      type: 'money',
      width: '10%'
    }, {
      key: 'data_atualizacao',
      label: 'Atualizado em',
      type: 'datetime',
      width: '15%'
    }, {
      key: 'data_criacao',
      label: 'Criado em',
      type: 'datetime',
      width: '15%'
    }])

    const onSubmit = handleSubmit(async ({ nome, valor_unit, codigo_barras, marca_id, subcategoria_id }) => {
      try {
        if (!selected.value?.id) {
          await execute('POST', '/produtos', {
            nome,
            valor_unit: Number(valor_unit),
            codigo_barras,
            subcategoria_id: Number(subcategoria_id) || null,
            marca_id: Number(marca_id) || null
          })
        } else {
          await execute('PATCH', '/produtos', {
            id: selected.value?.id,
            nome,
            valor_unit: Number(valor_unit),
            codigo_barras,
            subcategoria_id: Number(subcategoria_id) || null,
            marca_id: Number(marca_id) || null
          })
        }

        close()
        fetchEntities()
      } catch (e) {
        setFieldError('codigo_barras', e.message)
      }
    })

    const excluir = async () => {
      try {
        await execute('DELETE', '/produtos', {
          id: selected.value.id
        })

        fetchEntities()
        close()

        selected.value = null
      } catch (e) {
      }
    }

    onMounted((): void => {
      modal = new Modal(modalRef.value as Element, {
        backdrop: 'static',
        keyboard: false
      })
      modalExcluir = new Modal(modalExcluirRef.value as Element, {
        backdrop: 'static',
        keyboard: false
      })

      const im = new InputMask('decimal', {
        rightAlign: false,
        numericInput: true
      })
      im.mask(valorUnitRef.value as HTMLElement)

      fetchMarcas()
      fetchEntities()
      fetchSubcategorias()
    })

    return {
      modalRef,
      modalExcluirRef,
      open,
      close,

      entities,
      excluir,
      openExcluir,
      selected,
      columns,

      errors,
      nome,
      valor_unit,
      codigo_barras,
      onSubmit,
      marcas,
      marca_id,
      valorUnitRef,
      subcategorias
    }
  }
})
</script>
