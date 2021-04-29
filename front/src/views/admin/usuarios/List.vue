<template>
  <div>
    <AdminBody>
      <template v-slot:heading>
        <HeadingDefault name="Usuários">
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
              name="Usuários"
              :columns="columns"

              entitiyKey="id"
              :entities="entities"
            >
              <template v-slot:actions="{ selected }">
                <div class="d-flex justify-content-end">
                  <button type="button" class="btn btn-secondary btn-sm mr-1" @click="open(selected)">Editar</button>
                  <button type="button" class="btn btn-danger btn-sm" :disabled="userId === selected?.id" @click="openExcluir(selected)">Excluir</button>
                </div>
              </template>
            </DataTable>
          </div>

          <div ref="modalExcluirRef" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title">Excluir usuário</h5>
                  <button class="close" type="button" @click="close()" aria-label="Close">
                    <span aria-hidden="true">×</span>
                  </button>
                </div>
                <div class="modal-body">
                  <h6 v-if="!!selected">Tem certeza que deseja excluir o usuário "{{ selected.nome }}"?</h6>
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
                    <h5 class="modal-title">{{ selected === null ? 'Cadastrar usuário' : 'Editar usuário' }}</h5>
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
                      <label for="email">Email</label>
                      <input
                        type="text"
                        id="email"
                        class="form-control"
                        autocomplete="off"
                        name="email"
                        v-model="email"
                        :class="{ 'is-invalid': !!errors.email }"
                      />
                      <div class="invalid-feedback">
                        <small>{{ errors.email || 'default' }}</small>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="senha">Senha</label>
                      <input
                        type="password"
                        id="senha"
                        class="form-control"
                        autocomplete="off"
                        name="senha"
                        v-model="senha"
                        :class="{ 'is-invalid': !!errors.senha }"
                      />
                      <div class="invalid-feedback">
                        <small>{{ errors.senha || 'default' }}</small>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="senha">Confirmar senha</label>
                      <input
                        type="password"
                        id="confirm-senha"
                        class="form-control"
                        autocomplete="off"
                        name="confirmar_senha"
                        v-model="confirar_senha"
                        :class="{ 'is-invalid': !!errors.confirmar_senha }"
                      />
                      <div class="invalid-feedback">
                        <small>{{ errors.confirmar_senha || 'default' }}</small>
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
import { defineComponent, onMounted, ref, computed } from 'vue'

import AdminBody from '@/components/admin/Body.vue'
import HeadingDefault from '@/components/admin/HeadingDefault.vue'
import DataTable from '@/components/DataTable/DataTable.vue'

import { Modal } from 'bootstrap'

import * as yup from 'yup'
import { useForm, useField } from 'vee-validate'

import { execute } from '@/api'
import usePagination from '@/hooks/pagination'

export default defineComponent({
  name: 'UserList',
  components: {
    AdminBody,
    HeadingDefault,
    DataTable
  },

  setup () {
    const userId = computed((): string => {
      const token = window.localStorage.getItem('token') ?? ''

      const [_, payloadString] = token.split('.')

      const payload = JSON.parse(window.atob(payloadString))

      return payload.sub as string
    })

    let modal: Modal | null = null
    const modalRef = ref<Element>()

    let modalExcluir: Modal | null = null
    const modalExcluirRef = ref<Element>()

    const schema = yup.object({
      email: yup.string().email().required(),
      nome: yup.string().min(3).required(),
      senha: yup.string().min(8).required(),
      confirmar_senha: yup.string().required().test('match-pwd', 'As senhas devem ser iguais', function (value) {
        return this.parent.senha === value
      })
    })

    const { errors, handleSubmit, resetForm, setFieldError } = useForm({ validationSchema: schema })

    const selected = ref<any>(null)
    const { value: email } = useField('email')
    const { value: senha } = useField('senha')
    const { value: confirar_senha } = useField('confirmar_senha')
    const { value: nome } = useField('nome')

    function open (item: Record<string, string | undefined> | undefined) {
      if (typeof item !== 'undefined') {
        selected.value = item
        nome.value = item.nome as string
        email.value = item.email as string
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

      selected.value = null
    }

    const { entities, fetchEntities, columns } = usePagination('/usuarios', [{
      key: 'id',
      label: '#',
      type: 'numeric',
      width: '10%'
    }, {
      key: 'nome',
      label: 'Nome',
      width: '30%'
    }, {
      key: 'email',
      label: 'Email',
      width: '30%'
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

    const onSubmit = handleSubmit(async ({ email, senha, nome }) => {
      try {
        if (!selected.value?.id) {
          await execute('POST', '/usuarios', {
            email,
            senha,
            nome
          })
        } else {
          await execute('PATCH', '/usuarios', {
            email,
            senha,
            nome,
            id: selected.value?.id
          })
        }

        fetchEntities()

        close()
      } catch (e) {
        setFieldError('email', e.message)
      }
    })

    const excluir = async () => {
      try {
        await execute('DELETE', '/usuarios', {
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
    })

    return {
      modalRef,
      open,
      close,

      selected,
      errors,
      email,
      senha,
      confirar_senha,
      nome,
      onSubmit,
      entities,
      columns,
      modalExcluirRef,
      openExcluir,
      excluir,
      userId
    }
  }
})
</script>
