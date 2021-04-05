import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'

import Login from '../views/login/Login.vue'

import Panel from '../views/admin/panel/Panel.vue'
import Dashboard from '../views/admin/dashboard/Dashboard.vue'

import ProductList from '../views/admin/produtos/List.vue'
import UserList from '../views/admin/usuarios/List.vue'
import BrandList from '../views/admin/marcas/List.vue'
import Caixa from '../views/admin/caixa/Index.vue'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/admin',
    name: 'admin.index',
    component: Panel,

    // eslint-disable-next-line
    props: _ => ({
      title: process.env.VUE_APP_TITLE,
      version: process.env.VUE_APP_VERSION
    }),

    beforeEnter: (to, from, next) => {
      const token = window.localStorage.getItem('token')

      if (token === null) {
        next({ name: 'login' })
      }

      next()
    },

    children: [
      {
        path: '',
        redirect: '/admin/dashboard'
      },
      {
        path: 'dashboard',
        name: 'admin.dashboard',

        component: Dashboard
      },

      {
        path: 'produtos',
        name: 'admin.product.list',

        component: ProductList
      },
      {
        path: 'marcas',
        name: 'admin.brand.list',

        component: BrandList
      },

      {
        path: 'usuarios',
        name: 'admin.user.list',

        component: UserList
      }
    ]
  },

  {
    path: '/admin/caixa',
    name: 'admin.caixa',
    component: Caixa
  },

  {
    path: '/login',
    name: 'login',
    component: Login,

    beforeEnter: (to, from, next) => {
      const token = window.localStorage.getItem('token')

      if (token === null) {
        next()
      }

      next({ name: 'admin.dashboard' })
    },

    props: {
      title: process.env.VUE_APP_TITLE
    }
  },
  {
    path: '/',
    redirect: '/admin/dashboard'
  }
]

const history = createWebHistory(process.env.BASE_URL)

const router = createRouter({
  routes,
  history
})

export default router
