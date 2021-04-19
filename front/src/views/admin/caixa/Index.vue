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
            <div class="table-responsive">
              <table class="table table-bordered" cellspacing="0">
                <thead>
                  <tr>
                    <th>Nome</th>
                    <th>Qtd</th>
                    <th>Valor unit.</th>
                    <th>Total</th>
                  </tr>
                </thead>
                <tbody class="fixed-tbody">
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
              v-model="qnt"
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
      </div>
    </div>
  </div>
</template>

<style lang="scss">
  $topbar: 70px;

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

  .fixed-tbody {
    display: block;
    height: 50vh
  }
</style>

<script lang="ts">
import { defineComponent, onMounted, onBeforeUnmount, ref } from 'vue'

import onScan from 'onscan.js'
import hotkeys from 'hotkeys-js'

export default defineComponent({
  name: 'FrenteCaixa',
  setup () {
    const qnt = ref('1')
    const codigoBarras = ref('')

    onMounted(() => {
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
        onScan: (code: string, qty: number) => {
          console.log(code, qty)
        }
      })
    })

    onBeforeUnmount(() => {
      hotkeys.unbind()
      onScan.detachFrom(document)
    })

    function buscarAdicionar () {
      alert(codigoBarras.value)
    }

    return {
      qnt,
      codigoBarras,

      buscarAdicionar
    }
  }
})
</script>
