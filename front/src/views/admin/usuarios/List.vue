<template>
  <div>
    <AdminBody>
      <template v-slot:heading>
        <HeadingDefault name="Usuários">
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
                <h6 class="m-0 font-weight-bold text-primary">Usuários</h6>
              </div>
              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-bordered" cellspacing="0">
                    <thead>
                      <tr>
                        <th>#</th>
                        <th>Nome</th>
                        <th>Data atualização</th>
                        <th>Data criação</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-for="usuario in usuarios" :key="usuario.id">
                        <td>{{ usuario.id }}</td>
                        <td>{{ usuario.email }}</td>
                        <td>{{ usuario.data_atualizacao }}</td>
                        <td>{{ usuario.data_criacao }}</td>
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
                    <h5 class="modal-title">Cadastro de usuário</h5>
                    <button class="close" type="button" @click="close()" aria-label="Close">
                      <span aria-hidden="true">×</span>
                    </button>
                  </div>
                  <div class="modal-body">
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
                        ref="inputRef"
                        type="text"
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

interface Usuario {
  id: number;
  email: string;
  data_atualizacao: string;
  data_criacao: string;
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

    const { entities: usuarios, fetchEntities: fetchUsuarios } = useFetchEntities<Usuario>('/usuarios')

    const schema = yup.object({
      email: yup.string().email().required(),
      senha: yup.string().min(8).required()
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

    const { value: email } = useField('email')
    const { value: senha } = useField('senha')

    const onSubmit = handleSubmit(async ({ email, senha }) => {
      await execute('POST', '/usuarios', {
        email,
        senha
      })

      close()
      fetchUsuarios()
    })

    onMounted(() => {
      modal = new Modal(modalRef.value as Element, {
        backdrop: 'static'
      })

      fetchUsuarios()
    })

    return {
      modalRef,
      open,
      close,

      usuarios,

      errors,
      email,
      senha,
      onSubmit
    }
  }
})
</script>
