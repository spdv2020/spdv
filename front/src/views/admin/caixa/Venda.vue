<template>
  <div>
    <form name="opa" class="user" @submit.prevent="fecharVenda">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Fechar venda</h5>
            <button class="close" type="button" @click="closeFecharVenda()" aria-label="Close">
              <span aria-hidden="true">×</span>
            </button>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label for="valorFecharVenda">Sub total (R$)</label>
              <input
                type="text"
                class="form-control"
                autocomplete="off"
                :value="total"
                readonly
              />
            </div>
            <div class="form-group">
              <label for="email">Desconto (R$)</label>
              <input
                ref="valorDescontoRef"
                type="text"
                class="form-control"
                autocomplete="off"
                v-model="valorDesconto"
                :class="{ 'is-invalid': !!valorDescontoError }"
              />
              <div class="invalid-feedback">
                <small>{{ valorDescontoError || 'default' }}</small>
              </div>
            </div>
            <div class="form-group">
              <label for="email">Total (R$)</label>
              <input
                type="text"
                class="form-control"
                autocomplete="off"
                readonly
                :value="valorFinal"
              />
            </div>
            <div class="form-group">
              <label for="email">Valor recebido (R$)</label>
              <input
                ref="valorRecebidoRef"
                type="text"
                class="form-control"
                autocomplete="off"
                v-model="valorRecebido"
                :disabled="['DEBITO', 'CREDITO'].indexOf(metodoPagamento) !== -1"
                :class="{ 'is-invalid': !!valorRecebidoError }"
              />
              <div class="invalid-feedback">
                <small>{{ valorRecebidoError || 'default' }}</small>
              </div>
            </div>
            <div class="form-group">
              <label for="email">Troco (R$)</label>
              <input
                type="text"
                class="form-control"
                autocomplete="off"
                readonly
                :value="valorTroco"
              />
            </div>
            <div class="form-group">
              <label for="email">Forma de pagamento</label>
              <select class="form-control" v-model="metodoPagamento">
                <option value="DINHEIRO">Dinheiro</option>
                <option value="DEBITO">Débito</option>
                <option value="CREDITO">Crédito</option>
              </select>
            </div>
            <div class="form-group">
              <label for="email">CPF Cliente <small>(Opcional)</small></label>
              <input
                type="text"
                class="form-control"
                autocomplete="off"
                ref="cpfClienteRef"
                v-model="cpfCliente"
                :class="{ 'is-invalid': !!cpfClienteError }"
              />
              <div class="invalid-feedback">
                <small>{{ cpfClienteError || 'default' }}</small>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-link" type="button" @click="closeFecharVenda()">Cancelar</button>
            <button type="submit" class="btn btn-primary">Fechar venda</button>
          </div>
        </div>
      </div>
    </form>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref, computed, watch } from 'vue'

import InputMask from 'inputmask'

import BrV from 'br-validations'

export default defineComponent({
  name: 'Venda',
  props: {
    total: {
      type: String,
      required: true
    },
    venda_id: {
      type: Number
    }
  },
  emits: ['submit', 'close'],
  setup (props, ctx) {
    const valorDescontoRef = ref<Element>()
    const valorRecebidoRef = ref<Element>()
    const cpfClienteRef = ref<Element>()

    const valorDesconto = ref('0.00')
    const valorRecebido = ref('0.00')
    const metodoPagamento = ref('DINHEIRO')
    const cpfCliente = ref('')

    const valorSubtotalNumber = computed(() => Number(props.total.replace(/,/, '.')) || 0)
    const valorDescontoNumber = computed(() => Number(valorDesconto.value) || 0)
    const valorRecebidoNumber = computed(() => Number(valorRecebido.value) || 0)

    const valorFinalNumber = computed(() => valorSubtotalNumber.value - valorDescontoNumber.value)

    const valorFinal = computed(() => {
      return valorFinalNumber.value.toFixed(2).replace(/\./, ',')
    })

    const valorTrocoNumber = computed(() => valorRecebidoNumber.value - valorFinalNumber.value)

    const valorTroco = computed(() => {
      let valor = valorTrocoNumber.value
      if (valor < 0) {
        valor = 0
      }

      return valor.toFixed(2).replace(/\./, ',')
    })

    const valorDescontoError = computed(() => {
      if (valorDescontoNumber.value < 0) {
        return 'O valor deve ser maior ou igual a 0'
      }

      if (valorDescontoNumber.value >= valorSubtotalNumber.value) {
        return 'O valor de desconto deve ser menor que o valor da compra'
      }

      return ''
    })

    const valorRecebidoError = computed(() => {
      if (valorRecebidoNumber.value < valorFinalNumber.value) {
        return 'O valor recebido deve ser maior ou igual que o valor total'
      }

      return ''
    })

    const cpfClienteError = computed(() => {
      const cpf = cpfCliente.value.replace(/[^0-9]/g, '')
      if (cpf.length > 0) {
        if (!BrV.cpf.validate(cpfCliente.value)) {
          return 'O CPF precisa ser válido'
        }
      }

      return ''
    })

    watch(() => metodoPagamento.value, (metodoPagamento) => {
      console.log(metodoPagamento)
      if (['DEBITO', 'CREDITO'].indexOf(metodoPagamento) !== -1) {
        valorRecebido.value = valorFinalNumber.value.toFixed(2)
      } else {
        valorRecebido.value = '0.00'
      }
    })

    watch(() => valorDesconto.value, () => {
      if (['DEBITO', 'CREDITO'].indexOf(metodoPagamento.value) !== -1) {
        valorRecebido.value = valorFinalNumber.value.toFixed(2)
      }
    })

    watch(() => props.venda_id, () => {
      valorDesconto.value = '0.00'
      valorRecebido.value = '0.00'
      metodoPagamento.value = 'DINHEIRO'
      cpfCliente.value = ''
    })

    onMounted(() => {
      const im = new InputMask('decimal', {
        rightAlign: false,
        numericInput: true
      })
      im.mask(valorDescontoRef.value as HTMLElement)
      im.mask(valorRecebidoRef.value as HTMLElement)

      const imCPF = new InputMask('999.999.999-99')
      imCPF.mask(cpfClienteRef.value as HTMLElement)
    })

    function closeFecharVenda () {
      valorDesconto.value = '0.00'
      valorRecebido.value = '0.00'
      metodoPagamento.value = 'DINHEIRO'
      cpfCliente.value = ''
      ctx.emit('close')
    }

    const fecharVenda = () => {
      if (!valorDescontoError.value && !valorRecebidoError.value && !cpfClienteError.value) {
        ctx.emit('submit', {
          valorDesconto: valorDescontoNumber.value,
          valorRecebido: valorRecebidoNumber.value,
          metodoPagamento: metodoPagamento.value,
          cpfCliente: cpfCliente.value.replace(/[^0-9]/g, '')
        })
      }
    }

    return {
      valorDescontoRef,
      valorRecebidoRef,
      closeFecharVenda,
      valorDesconto,
      valorFinal,
      valorDescontoError,
      fecharVenda,
      metodoPagamento,
      valorRecebido,
      valorRecebidoError,
      valorTroco,
      cpfClienteRef,
      cpfCliente,
      cpfClienteError
    }
  }
})
</script>
