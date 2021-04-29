<template>
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
            <h5 style="margin: 0">{{ caixaAberto ? `Caixa #${caixaId}` : 'Caixa fechado' }}</h5>
          </div>
          <div class="col-sm-4">
            <!-- <h5>Usuário</h5> -->
          </div>
        </div>
      </div>
      <div class="col-sm-9 content content-table pl-5 pr-5 py-5">
        <div class="card shadow mb-4">
          <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Produtos</h6>
          </div>
          <div class="card-body">
            <div class="table-responsive tableFixHead">
              <table class="table table-bordered" cellspacing="0">
                <thead>
                  <tr>
                    <th style="width: 60%">Nome</th>
                    <th style="width: 10%; text-align: right;">Qtd</th>
                    <th style="width: 15%; text-align: right;">Valor unit. (R$)</th>
                    <th style="width: 15%; text-align: right;">Total (R$)</th>
                  </tr>
                </thead>
                <tbody class="fixed-tbody">
                  <tr v-for="produto in produtos" :key="produto.venda_produto_id">
                    <td>{{ produto.nome }}</td>
                    <td style="text-align: right;">{{ produto.quantidade }}</td>
                    <td style="text-align: right;">{{ Number(produto.valor_unit).toFixed(2).replace(/\./, ',') }}</td>
                    <td style="text-align: right;">{{ Number(produto.total).toFixed(2).replace(/\./, ',') }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="help">
          <h6>ESC - Cancelar venda</h6>
          <h6>F1 - Fechar venda</h6>
          <h6>F2 - Informar quantidade</h6>
        </div>
        <div class="help">
          <h6>F7 - Realizar aporte</h6>
          <h6>F8 - Realizar sangria</h6>
          <h6>F10 - Fechar caixa</h6>
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
            <label for="nome">Quantidade</label>
            <input
              ref="quantidadeInput"
              type="text"
              id="nome"
              class="form-control"
              autocomplete="off"
              name="nome"
              v-model="qtd"
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
              v-model="produtoNome"
            />
          </div>
          <div class="form-group input-group-lg">
            <label for="nome">Preço total (R$)</label>
            <input
              type="text"
              readonly
              id="nome"
              class="form-control"
              autocomplete="off"
              v-model="produtoTotal"
            />
          </div>

          <button style="display: none;" type="submit">Add</button>
        </form>

        <div class="divider"></div>

        <form>
          <div class="form-group input-group-lg">
            <label for="sub_total">Sub total (R$)</label>
            <input
              type="text"
              readonly
              id="sub_total"
              class="form-control"
              autocomplete="off"
              name="sub_total"
              v-model="sub_total"
            />
          </div>
        </form>
      </div>
    </div>

    <div ref="modalAbrirCaixaRef" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
      <form class="user" @submit="abrirCaixa">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Abrir caixa</h5>
              <button class="close" type="button" @click="closeAbrirCaixa()" aria-label="Close">
                <span aria-hidden="true">×</span>
              </button>
            </div>
            <div class="modal-body">
              <div class="form-group">
                <label for="email">Aporte (R$)</label>
                <input
                  ref="aporteAbrirCaixaRef"
                  type="text"
                  id="aporteAbrirCaixa"
                  class="form-control"
                  autocomplete="off"
                  name="aporteAbrirCaixa"
                  v-model="aporteAbrirCaixa"
                  :class="{ 'is-invalid': !!errorsAbrirCaixa.aporteAbrirCaixa }"
                />
                <div class="invalid-feedback">
                  <small>{{ errorsAbrirCaixa.aporteAbrirCaixa || 'default' }}</small>
                </div>
              </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-link" type="button" @click="closeAbrirCaixa()">Cancelar</button>
            <button type="submit" class="btn btn-primary">Abrir caixa</button>
          </div>
          </div>
        </div>
      </form>
    </div>

    <div ref="modalCaixaMovimentoRef" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
      <Movimento :tipo="movimentoTipo" :total="valorEmCaixa" @submit="caixaMovimento" @close="closeCaixaMovimento" />
    </div>

    <div ref="modalFecharVendaRef" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
      <Venda :venda_id="vendaId" :total="sub_total" @submit="fecharVenda" @close="closeFecharVenda" />
    </div>

    <div ref="modalCancelarVendaRef" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Cancelar venda</h5>
            <button class="close" type="button" @click="closeCancelarVenda()" aria-label="Close">
              <span aria-hidden="true">×</span>
            </button>
          </div>
          <div class="modal-body">
            <h6>Tem certeza que deseja cancelar a venda atual?</h6>
          </div>
          <div class="modal-footer">
            <button class="btn btn-link" type="button" @click="closeCancelarVenda()">Não</button>
            <button type="button" class="btn btn-primary" @click="cancelarVenda()">Sim</button>
          </div>
        </div>
      </div>
    </div>

    <div ref="modalFecharCaixaRef" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Fechar caixa</h5>
            <button class="close" type="button" @click="closeFecharCaixa()" aria-label="Close">
              <span aria-hidden="true">×</span>
            </button>
          </div>
          <div class="modal-body">
            <h6>Tem certeza que deseja fechar o caixa?</h6>
            <br />
            <h6>Valor em caixa: <strong>R$ {{ valorEmCaixa }}</strong></h6>
          </div>
          <div class="modal-footer">
            <button class="btn btn-link" type="button" @click="closeFecharCaixa()">Não</button>
            <button type="button" class="btn btn-primary" @click="fecharCaixa()">Sim</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  $topbar: 70px;

  .divider {
    border-bottom: 1px solid #e3e6f0;
    padding-top: 40px;
    margin-bottom: 40px
  }

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
        font-weight: bold;

        font-size: 18px;
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
import { defineComponent, onMounted, onBeforeUnmount, ref, nextTick, computed } from 'vue'

import onScan from 'onscan.js'
import hotkeys from 'hotkeys-js'

import { execute } from '@/api'

import { Modal } from 'bootstrap'

import * as yup from 'yup'
import { useForm, useField } from 'vee-validate'

import InputMask from 'inputmask'

import Venda from './Venda.vue'
import Movimento from './Movimento.vue'

export default defineComponent({
  name: 'FrenteCaixa',
  components: {
    Venda,
    Movimento
  },
  setup () {
    const caixaId = ref('')
    const vendaId = ref('')
    const caixaAberto = ref(false)
    const valorEmCaixa = ref('0.00')
    const movimentoTipo = ref('')

    const produtos = ref<any[]>([])
    const sub_total = ref('0.00')

    const qtd = ref('1')
    const codigoBarras = ref('')
    const produtoNome = ref('')
    const produtoTotal = ref('')

    const quantidadeInput = ref<Element>()
    const aporteAbrirCaixaRef = ref<Element>()

    let modalAbrirCaixa: Modal | null = null
    const modalAbrirCaixaRef = ref<Element>()

    let modalCaixaMovimento: Modal | null = null
    const modalCaixaMovimentoRef = ref<Element>()

    let modalFecharVenda: Modal | null = null
    const modalFecharVendaRef = ref<Element>()

    let modalCancelarVenda: Modal | null = null
    const modalCancelarVendaRef = ref<Element>()

    let modalFecharCaixa: Modal | null = null
    const modalFecharCaixaRef = ref<Element>()

    const schemaAbrirCaixa = yup.object({
      aporteAbrirCaixa: yup.number().min(0)
    })

    const { errors: errorsAbrirCaixa, handleSubmit: handleSubmitAbrirCaixa } = useForm({ validationSchema: schemaAbrirCaixa })

    const { value: aporteAbrirCaixa } = useField('aporteAbrirCaixa')

    aporteAbrirCaixa.value = '0.00'

    function resetForm () {
      qtd.value = '1'
      codigoBarras.value = ''
      produtoNome.value = ''
      produtoTotal.value = ''
    }

    function openAbrirCaixa () {
      if (modalAbrirCaixa) {
        modalAbrirCaixa.show()
      }
    }

    function closeAbrirCaixa (params: { closeWindow: boolean } = { closeWindow: true }) {
      if (modalAbrirCaixa) {
        modalAbrirCaixa.hide()
      }

      if (params.closeWindow) {
        window.close()
      }
    }

    async function openCaixaMovimento (tipo: string) {
      // eslint-disable-next-line @typescript-eslint/no-use-before-define
      closeFecharCaixa()
      // eslint-disable-next-line @typescript-eslint/no-use-before-define
      closeFecharVenda()

      movimentoTipo.value = tipo
      await nextTick()

      if (modalCaixaMovimento) {
        modalCaixaMovimento.show()
      }
    }

    function closeCaixaMovimento () {
      if (modalCaixaMovimento) {
        modalCaixaMovimento.hide()
      }

      movimentoTipo.value = ''
    }

    async function openFecharVenda () {
      if (produtos.value.length === 0) {
        return
      }

      // eslint-disable-next-line @typescript-eslint/no-use-before-define
      closeFecharCaixa()
      closeCaixaMovimento()

      await nextTick()

      if (modalFecharVenda) {
        modalFecharVenda.show()
      }
    }

    function closeFecharVenda () {
      if (modalFecharVenda) {
        modalFecharVenda.hide()
      }
    }

    function novaVenda () {
      sub_total.value = '0.00'
      produtos.value = []
      codigoBarras.value = ''
      qtd.value = ''
    }

    async function refreshCaixa (params: { clear: boolean }) {
      try {
        const result = await execute('GET', '/caixa')

        const { caixa_id, venda, caixa_total } = result
        if (caixa_id === -1) {
          caixaId.value = ''
          valorEmCaixa.value = '0.00'
          caixaAberto.value = false
          produtos.value = []
          vendaId.value = ''

          openAbrirCaixa()

          return
        }

        caixaId.value = caixa_id
        caixaAberto.value = true
        valorEmCaixa.value = caixa_total.toFixed(2).replace(/\./, ',')

        if (venda) {
          const { total: totalVenda, produtos: lista, venda_id } = venda

          vendaId.value = venda_id
          sub_total.value = Number(totalVenda).toFixed(2).replace(/\./, ',')
          produtos.value = lista
        } else {
          novaVenda()
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

        const { venda_produto_id, produto } = result
        if (!venda_produto_id) {
          alert('produto não encontrado')
          resetForm()
          return
        }

        await nextTick()

        produtoNome.value = produto.nome
        produtoTotal.value = Number(produto.total).toFixed(2).replace(/\./, ',')

        if (quantidadeInput.value) {
          (quantidadeInput.value as HTMLElement).blur()
        }

        refreshCaixa({ clear: true })
      } catch (e) {
        alert('produto não encontrado')
        resetForm()
      }
    }

    const abrirCaixa = handleSubmitAbrirCaixa(async ({ aporteAbrirCaixa: aporte }) => {
      try {
        const result = await execute('POST', '/caixa', {
          aporte: Number(aporte) || 0
        })

        const { caixa_id } = result
        if (!caixa_id) {
          alert('Não foi possivel abrir o caixa')
          return
        }

        refreshCaixa({ clear: true })
        closeAbrirCaixa({ closeWindow: false })

        aporteAbrirCaixa.value = '0.00'
      } catch (e) {
        alert('Não foi possivel abrir o caixa')
      }
    })

    const caixaMovimento = async (valor: number) => {
      try {
        const result = await execute('POST', '/caixa/movimento', {
          valor: valor,
          tipo: movimentoTipo.value
        })

        const { caixa_id } = result
        if (!caixa_id) {
          alert('Não foi possivel realizar a movimentação')
          return
        }

        refreshCaixa({ clear: true })
        closeCaixaMovimento()
      } catch (e) {
        alert(e.message)
      }
    }

    function openCancelarVenda () {
      if (produtos.value.length === 0) {
        return
      }

      // eslint-disable-next-line @typescript-eslint/no-use-before-define
      closeFecharCaixa()
      closeCaixaMovimento()
      closeFecharVenda()

      if (modalCancelarVenda) {
        modalCancelarVenda.show()
      }
    }

    function closeCancelarVenda () {
      if (modalCancelarVenda) {
        modalCancelarVenda.hide()
      }
    }

    function openFecharCaixa () {
      closeCancelarVenda()
      closeCaixaMovimento()
      closeFecharVenda()

      if (modalFecharCaixa) {
        modalFecharCaixa.show()
      }
    }

    function closeFecharCaixa () {
      if (modalFecharCaixa) {
        modalFecharCaixa.hide()
      }
    }

    async function cancelarVenda () {
      try {
        const result = await execute('DELETE', '/caixa/venda')

        const { venda_id } = result
        if (!venda_id) {
          alert('Não foi possivel cancelar a venda')
          return
        }

        novaVenda()
        refreshCaixa({ clear: true })
        closeCancelarVenda()
      } catch (e) {
        alert('Não foi possivel cancelar a venda')
      }
    }

    async function fecharCaixa () {
      try {
        const result = await execute('DELETE', '/caixa')

        const { caixa } = result
        if (!caixa) {
          alert('Não foi possivel fechar o caixa')
          return
        }

        novaVenda()
        refreshCaixa({ clear: true })
        closeFecharCaixa()
      } catch (e) {
        alert(e.message)
      }
    }

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    async function fecharVenda ({ valorDesconto, valorRecebido, metodoPagamento, cpfCliente }: any) {
      try {
        const result = await execute('POST', '/caixa/venda', {
          valorDesconto,
          valorRecebido,
          metodoPagamento,
          cpfCliente
        })

        const { venda_id } = result
        if (!venda_id) {
          alert('Não foi possivel fechar a venda')
          return
        }

        novaVenda()
        refreshCaixa({ clear: true })
        closeFecharVenda()
      } catch (e) {
        alert(e.message)
      }
    }

    onMounted(() => {
      modalAbrirCaixa = new Modal(modalAbrirCaixaRef.value as Element, {
        backdrop: 'static',
        keyboard: false
      })

      modalCancelarVenda = new Modal(modalCancelarVendaRef.value as Element, {
        backdrop: 'static',
        keyboard: false
      })

      modalFecharCaixa = new Modal(modalFecharCaixaRef.value as Element, {
        backdrop: 'static',
        keyboard: false
      })

      modalCaixaMovimento = new Modal(modalCaixaMovimentoRef.value as Element, {
        backdrop: 'static',
        keyboard: false
      })

      modalFecharVenda = new Modal(modalFecharVendaRef.value as Element, {
        backdrop: 'static',
        keyboard: false
      })

      const im = new InputMask('decimal', {
        rightAlign: false,
        numericInput: true
      })
      im.mask(aporteAbrirCaixaRef.value as HTMLElement)

      refreshCaixa({
        clear: true
      })

      hotkeys('esc', (e) => {
        e.preventDefault()
        openCancelarVenda()
      })

      hotkeys('f7', (e) => {
        e.preventDefault()
        openCaixaMovimento('aporte')
      })

      hotkeys('f8', (e) => {
        e.preventDefault()
        openCaixaMovimento('sangria')
      })

      hotkeys('f10', (e) => {
        e.preventDefault()
        openFecharCaixa()
      })

      hotkeys('f1', (e) => {
        e.preventDefault()

        openFecharVenda()
      })

      hotkeys('f2', (e) => {
        e.preventDefault()

        if (quantidadeInput.value) {
          (quantidadeInput.value as HTMLElement).focus()
        }
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
      sub_total,
      produtoNome,
      produtoTotal,

      buscarAdicionar,
      abrirCaixa,
      quantidadeInput,
      modalCancelarVendaRef,
      closeCancelarVenda,
      cancelarVenda,
      closeAbrirCaixa,
      modalAbrirCaixaRef,
      aporteAbrirCaixa,
      errorsAbrirCaixa,
      aporteAbrirCaixaRef,
      modalFecharCaixaRef,
      closeFecharCaixa,
      fecharCaixa,
      caixaId,
      valorEmCaixa,
      closeCaixaMovimento,
      modalCaixaMovimentoRef,
      movimentoTipo,
      caixaMovimento,
      modalFecharVendaRef,
      fecharVenda,
      closeFecharVenda,
      vendaId
    }
  }
})
</script>
