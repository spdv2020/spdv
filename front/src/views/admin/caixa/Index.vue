<template>
  <div v-if="!caixaAberto" class="backdrop d-flex align-items-center justify-content-center">
    <button type="button" class="btn btn-warning btn-lg" @click="abrirCaixa()">ABRIR CAIXA</button>
  </div>
  <div class="wrapper container-fluid bg-white d-flex flex-column m-0 p-0">
    <div class="row m-0">
      <div class="col-sm-12 topbar p-0">
        <div class="d-flex">
          <div class="col-sm-2 p-0">
            <a class="sidebar-brand d-flex align-items-center justify-content-center">
              <div class="sidebar-brand-icon rotate-n-15">
                <i class="fas fa-sun"></i>
              </div>
              <div class="sidebar-brand-text mx-3">
                SPDV
                <sup>0.1.0</sup>
              </div>
            </a>
          </div>
          <div class="col-sm-6 d-flex align-items-center text-primary text-bold">
            <h5>Caixa aberto</h5>
          </div>
          <div class="col-sm-4">
            <!-- <h5>Usuário</h5> -->
          </div>
        </div>
      </div>
      <div class="col-sm-9 content content-table pl-5 pr-5 py-5">
        <div class="card shadow mb-4">
          <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Cupom</h6>
          </div>
          <div class="card-body">
            <div class="table-responsive tableFixHead">
              <table class="table table-bordered" cellspacing="0">
                <thead>
                  <tr>
                    <th style="width: 65%">Nome</th>
                    <th style="width: 10%">Qtd</th>
                    <th style="width: 10%">Valor unit.</th>
                    <th style="width: 15%">Total</th>
                  </tr>
                </thead>
                <tbody class="fixed-tbody">
                  <tr v-for="produto in produtos" :key="produto.venda_produto_id">
                    <td>{{ produto.nome }}</td>
                    <td>{{ produto.quantidade }}</td>
                    <td>{{ produto.valor_unit }}</td>
                    <td>{{ produto.total }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="help">
          <h6>F1 - Mais atalhos</h6>
          <h6>F2 - Cancelar venda</h6>
          <h6>F3 - Fechar caixa</h6>
        </div>
      </div>
      <div class="col-sm-3 bg-white content content-form">
        <form @submit.prevent="buscarAdicionar">
          <div class="form-group input-group-lg">
            <label for="nome">Código de barras</label>
            <input
              type="text"
              id="nome"
              class="form-control"
              autocomplete="off"
              name="nome"
              v-model="codigoBarras"
            />
          </div>
          <div class="form-group input-group-lg">
            <label for="nome">Nome do produto</label>
            <input
              type="text"
              id="nome"
              class="form-control"
              autocomplete="off"
              name="nome"
              readonly
            />
          </div>
          <div class="form-group input-group-lg">
            <label for="nome">Quantidade</label>
            <input
              type="text"
              id="nome"
              class="form-control"
              autocomplete="off"
              name="nome"
              v-model="qtd"
            />
          </div>
          <div class="form-group input-group-lg">
            <label for="nome">Preço total</label>
            <input
              type="text"
              readonly
              id="nome"
              class="form-control"
              autocomplete="off"
              name="nome"
            />
          </div>

          <button style="display: none;" type="submit">Add</button>
        </form>

        <div class="divider"></div>

        <div class="form-group input-group-lg">
          <label for="nome">Total venda</label>
          <input
            type="text"
            readonly
            id="nome"
            class="form-control"
            autocomplete="off"
            name="nome"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  $topbar: 70px;

  .backdrop {
    position: absolute;
    height: 100vh;
    width: 100vw;
    background-color: rgb(63 81 181 / 90%);
    z-index: 2;
  }

  .sidebar-brand {
    background: $primary;
    text-decoration: none;
    font-size: 1rem;
    font-weight: 800;
    height: $topbar;
    text-align: center;
    text-transform: uppercase;
    letter-spacing: 0.05rem;
    z-index: 1;

    color: white;

    .sidebar-brand-icon i {
      font-size: 2rem;
    }
  }

  .wrapper {
    height: 100vh;
    width: 100vw;

    color: black;

    .row {
      height: 100%;
    }
  }

  .topbar {
    height: $topbar;
  }

  .content {
    height: calc(100% - #{$topbar});

    &.content-table {
      background-color: #4e73de14;
    }

    &.content-form {
      padding-left: 1.5rem;
      padding-right: 1.5rem;

      label {
        color: $primary;
        font-weight: bold;
      }
    }

    .help {
      padding-left: 8rem;
      padding-right: 8rem;
      display: flex;
      align-items: stretch;
      justify-content: space-around;

      h6 {
        color: #4e72deee;
        display: inline-block;
      }
    }
  }

  .tableFixHead    { overflow: auto; height: 50vh; }
  .tableFixHead th { position: sticky; top: 0; }

  /* Just common table stuff. */
  table  { border-collapse: collapse; width: 100%; }
  th, td { padding: 8px 16px; }
  th     { background:#eee; }
</style>

<script lang="ts">
import { defineComponent, onMounted, onBeforeUnmount, ref, nextTick } from 'vue'

import onScan from 'onscan.js'
import hotkeys from 'hotkeys-js'

import { execute } from '@/api'

export default defineComponent({
  name: 'FrenteCaixa',
  setup () {
    const caixaAberto = ref(false)
    const produtos = ref<any[]>([])
    const total = ref('0.00')

    const qtd = ref('1')
    const codigoBarras = ref('')

    function resetForm () {
      qtd.value = '1'
      codigoBarras.value = ''
    }

    async function refreshCaixa (params: { clear: boolean }) {
      try {
        const result = await execute('GET', '/caixa')

        const { caixa_id, venda } = result
        if (caixa_id === -1) {
          caixaAberto.value = false
          produtos.value = []

          return
        }

        caixaAberto.value = true

        if (venda) {
          const { total: totalVenda, produtos: lista } = venda

          total.value = totalVenda
          produtos.value = lista
        }

        if (params.clear) {
          resetForm()
        }
      } catch (e) {

      }
    }

    async function adicionarProduto () {
      try {
        const result = await execute('POST', '/caixa/produto', {
          codigo_barras: codigoBarras.value,
          qtd: qtd.value
        })

        const { venda_produto_id } = result
        if (!venda_produto_id) {
          alert('produto não encontrado')
          resetForm()
          return
        }

        refreshCaixa({ clear: true })
      } catch (e) {
        alert('produto não encontrado')
        resetForm()
      }
    }

    async function abrirCaixa () {
      try {
        const result = await execute('POST', '/caixa')

        const { caixa_id } = result
        if (!caixa_id) {
          alert('Não foi possivel abrir o caixa')
          return
        }

        refreshCaixa({ clear: true })
      } catch (e) {
        alert('Não foi possivel abrir o caixa')
      }
    }

    onMounted(() => {
      refreshCaixa({
        clear: true
      })

      hotkeys('f1', (e) => {
        e.preventDefault()
        alert('opa')
      })

      hotkeys('f2', (e) => {
        e.preventDefault()
      })

      hotkeys('f3', (e) => {
        e.preventDefault()
      })

      onScan.attachTo(document, {
        suffixesCodes: [13],
        reactToPaste: true,
        onScan: async (code: string, qty: number) => {
          codigoBarras.value = code
          await nextTick()

          adicionarProduto()
        }
      })
    })

    onBeforeUnmount(() => {
      hotkeys.unbind()
      onScan.detachFrom(document)
    })

    function buscarAdicionar () {
      adicionarProduto()
    }

    return {
      caixaAberto,
      qtd,
      codigoBarras,
      produtos,

      buscarAdicionar,
      abrirCaixa
    }
  }
})
</script>
