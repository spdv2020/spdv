<template>
  <div>
    <AdminBody>
      <template v-slot:heading>
        <HeadingDefault name="Dashboard" />
      </template>

      <template v-slot:default>
        <!-- Content Row -->
        <div class="row">
          <!-- Earnings (Monthly) Card Example -->
          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
              <div class="card-body">
                <div class="row no-gutters align-iteml-center">
                  <div class="col me2">
                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Data</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">28/04/2021</div>
                  </div>
                  <div class="col-auto">
                    <i class="fas fa-calendar fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Earnings (Monthly) Card Example -->
          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
              <div class="card-body">
                <div class="row no-gutters align-iteml-center">
                  <div class="col me2">
                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Vendas do dia</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">R$ 215,00</div>
                  </div>
                  <div class="col-auto">
                    <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Earnings (Monthly) Card Example -->
          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
              <div class="card-body">
                <div class="row no-gutters align-iteml-center">
                  <div class="col me2">
                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Vendas do mês</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">R$ 3000,00</div>
                  </div>
                  <div class="col-auto">
                    <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Earnings (Monthly) Card Example -->
          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
              <div class="card-body">
                <div class="row no-gutters align-iteml-center">
                  <div class="col me2">
                    <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Produto mais vendido</div>
                    <div class="row no-gutters align-iteml-center">
                      <div class="col-auto">
                        <div class="h5 mb-0 me3 font-weight-bold text-gray-800">50%</div>
                      </div>
                      <div class="col">
                        <div class="progress progress-sm me2">
                          <div
                            class="progress-bar bg-info"
                            role="progressbar"
                            style="width: 50%"
                            aria-valuenow="50"
                            aria-valuemin="0"
                            aria-valuemax="100"
                          ></div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-auto">
                    <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col-md-12" style="height: 300px">
            <div class="card border-left-info shadow h-100 py-2">
              <div class="card-body">
                <canvas ref="chartMesRef"></canvas>
              </div>
            </div>
          </div>
        </div>
      </template>
    </AdminBody>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue'

import AdminBody from '@/components/admin/Body.vue'
import HeadingDefault from '@/components/admin/HeadingDefault.vue'

import { Chart, registerables } from 'chart.js'

Chart.register(...registerables)

export default defineComponent({
  name: 'Dashboard',
  components: {
    AdminBody,
    HeadingDefault
  },
  setup () {
    const chartMesRef = ref<Element>()

    onMounted(() => {
      const ctx = (chartMesRef.value as HTMLCanvasElement).getContext('2d')

      if (ctx !== null) {
        const b = new Chart(ctx, {
          type: 'line',
          data: {
            labels: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Dez'],
            datasets: [
              {
                backgroundColor: 'rgb(78 115 223 / 90%)',
                pointBorderColor: 'rgb(78 115 223 / 100%)',
                borderColor: 'rgb(78 115 223 / 60%)',
                label: 'Vendas',
                data: [
                  300.25,
                  1000.20,
                  300,
                  560,
                  780,
                  2300,
                  1500,
                  1200,
                  1700,
                  1700,
                  1500,
                  2000
                ]
              }
            ]
          },
          options: {
            responsive: true,
            plugins: {
              legend: {
                position: 'top'
              },
              title: {
                display: true,
                text: 'Vendas por mês'
              }
            },
            maintainAspectRatio: false
          }
        })
      }
    })

    return {
      chartMesRef
    }
  }
})
</script>
