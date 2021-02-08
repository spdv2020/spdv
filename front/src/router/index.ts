import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'

import Login from '../views/login/Login.vue'

import Panel from '../views/admin/panel/Panel.vue'
import Dashboard from '../views/admin/dashboard/Dashboard.vue'

import ProductList from '../views/admin/produtos/List.vue'
import UserList from '../views/admin/usuarios/List.vue'

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
        path: 'usuarios',
        name: 'admin.user.list',

        component: UserList
      }
    ]
  },

  {
    path: '/login',
    name: 'Login',
    component: Login,

    props: {
      title: process.env.VUE_APP_TITLE
    }
  }
]

const history = createWebHistory(process.env.BASE_URL)

const router = createRouter({
  routes,
  history
})

export default router
