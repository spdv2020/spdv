<template>
  <div>
    <form name="opa" class="user" @submit.prevent="caixaMovimento">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Realizar {{ tipo === 'aporte' ? 'Aporte' : 'Sangria' }}</h5>
            <button class="close" type="button" @click="closeCaixaMovimento()" aria-label="Close">
              <span aria-hidden="true">×</span>
            </button>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label for="valorCaixaMovimento">{{ tipo === 'aporte' ? 'Aporte' : 'Sangria' }} (R$)</label>
              <input
                ref="valorCaixaMovimentoRef"
                type="text"
                id="valorCaixaMovimento"
                class="form-control"
                autocomplete="off"
                name="valorCaixaMovimento"
                v-model="valorCaixaMovimento"
                :class="{ 'is-invalid': !!valorCaixaMovimentoError }"
              />
              <div class="invalid-feedback">
                <small>{{ valorCaixaMovimentoError || 'default' }}</small>
              </div>
            </div>
            <div class="form-group">
              <label for="email">Valor após movimentação (R$)</label>
              <input
                type="text"
                class="form-control"
                autocomplete="off"
                :value="valorApos"
                readonly
              />
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-link" type="button" @click="closeCaixaMovimento()">Cancelar</button>
            <button type="submit" class="btn btn-primary">Realizar movimentação</button>
          </div>
        </div>
      </div>
    </form>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref, watch, computed } from 'vue'

import InputMask from 'inputmask'

export default defineComponent({
  name: 'Movimento',
  props: {
    tipo: {
      type: String,
      required: true
    },
    total: {
      type: String,
      required: true
    }
  },
  emits: ['submit', 'close'],
  setup (props, ctx) {
    const valorCaixaMovimentoRef = ref<Element>()

    const valorCaixaMovimento = ref('0.01')

    watch(() => props.total, () => {
      valorCaixaMovimento.value = '0.01'
    })

    const valorCaixaMovimentoError = computed(() => {
      const valor = Number(valorCaixaMovimento.value)

      if (valor <= 0) {
        return 'O valor deve ser maior que 0'
      }

      if (props.tipo === 'sangria') {
        const total = Number(props.total.replace(',', '.')) || 0
        if (valor > total) {
          return `O valor deve ser menor que ${props.total}`
        }
      }

      return ''
    })

    const caixaMovimento = () => {
      if (!valorCaixaMovimentoError.value) {
        ctx.emit('submit', Number(valorCaixaMovimento.value) || 0)
      }
    }

    onMounted(() => {
      const im = new InputMask('decimal', {
        rightAlign: false,
        numericInput: true
      })
      im.mask(valorCaixaMovimentoRef.value as HTMLElement)
    })

    function closeCaixaMovimento () {
      ctx.emit('close')
    }

    const valorApos = computed(() => {
      let valor = (Number(props.total.replace(/,/, '.')) + (Number(valorCaixaMovimento.value) * (props.tipo === 'sangria' ? -1 : 1)))
      if (valor < 0) {
        valor = 0
      }

      return valor.toFixed(2).replace(/\./, ',')
    })

    return {
      valorCaixaMovimentoRef,
      valorCaixaMovimento,
      caixaMovimento,
      valorApos,
      closeCaixaMovimento,
      valorCaixaMovimentoError
    }
  }
})
</script>
