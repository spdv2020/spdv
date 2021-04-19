<template>
  <ul
    class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion"
    :class="{ 'toggled': !open }"
  >
    <!-- Sidebar - Brand -->
    <a class="sidebar-brand d-flex align-iteml-center justify-content-center" href="index.html">
      <div class="sidebar-brand-icon rotate-n-15">
        <i class="fas fa-sun"></i>
      </div>
      <div class="sidebar-brand-text mx-3">
        {{ title }}
        <sup>{{ version }}</sup>
      </div>
    </a>

    <!-- Divider -->
    <hr class="sidebar-divider my-0" />

    <template v-for="(group, i) in items" :key="i">
      <!-- Heading -->
      <div
        v-if="group.name && group.name != ''"
        class="sidebar-heading text-truncate"
      >{{ group.name }}</div>

      <template v-for="(menu, j) in group.menus" :key="j">
        <li class="nav-item">
          <a
            class="nav-link collapsed"
            aria-expanded="true"
            :data-target="`#sidebar-collapse-${i}-${j}`"
            :aria-controls="`sidebar-collapse-${i}-${j}`"
            :href="menu.link || '#'"
            :data-toggle="menu.subgroups !== undefined && menu.subgroups.length !== 0 ? 'collapse' : undefined"
          >
            <i :class="menu.icon"></i>
            <span>{{ menu.name }}</span>
          </a>
          <div
            :id="`sidebar-collapse-${i}-${j}`"
            class="collapse"
            aria-labelledby="headingTwo"
            v-if="menu.subgroups !== undefined && menu.subgroups.length !== 0"
          >
            <div class="bg-white py-2 collapse-inner rounded">
              <template v-for="(subgroup, k) in menu.subgroups" :key="k">
                <h6 v-if="subgroup.name !== undefined" class="collapse-header">{{ subgroup.name }}</h6>
                <template v-for="(link, l) in subgroup.links" :key="l">
                  <a class="collapse-item" href="buttons.html">{{ link.name }}</a>
                </template>
              </template>
            </div>
          </div>
        </li>
      </template>

      <hr class="sidebar-divider" />
    </template>

    <!-- Sidebar Toggler (Sidebar) -->
    <div class="text-center d-none d-md-inline">
      <button class="rounded-circle border-0 btn-toggle" @click="toggle"></button>
    </div>
  </ul>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

interface MenuGroup {
  name?: string;
  menus: Menu[];
}

interface Menu {
  name: string;
  icon: string;

  link?: string;
  subgroups?: MenuSubgroup[];
}

interface MenuSubgroup {
  name?: string;
  links: MenuLink[];
}

interface MenuLink {
  name: string;
  link: string;
}

export default defineComponent({
  name: 'AdminSidebar',

  props: {
    title: String,
    version: String,

    open: Boolean
  },

  emits: ['update:open'],

  setup (props, { emit }) {
    function toggle () {
      emit('update:open', !props.open)
    }

    const items: MenuGroup[] = [
      {
        menus: [
          {
            name: 'Dashboard',
            icon: 'fas fa-fw fa-tachometer-alt',
            link: '/admin/dashboard'
          }
        ]
      },
      {
        name: 'Caixa',
        menus: [
          {
            name: 'Frente de caixa',
            icon: 'fas fa-fw fa-dollar-sign',
            link: '/admin/caixa'
          }
        ]
      },
      {
        name: 'Cadastros',
        menus: [
          {
            name: 'Produtos',
            icon: 'fas fa-fw fa-cog',
            link: '/admin/produtos'
          },
          {
            name: 'Categorias',
            icon: 'fas fa-fw fa-cog',
            link: '/admin/categorias'
          },
          {
            name: 'Subcategorias',
            icon: 'fas fa-fw fa-cog',
            link: '/admin/subcategorias'
          },
          {
            name: 'Marcas',
            icon: 'fas fa-fw fa-cog',
            link: '/admin/marcas'
          }
        ]
      },
      // {
      //   name: 'Relatórios',
      //   menus: [
      //     {
      //       name: 'Vendas',
      //       icon: 'fas fa-fw fa-cog',
      //       link: undefined
      //     }
      //   ]
      // },
      {
        name: 'Configurações',
        menus: [
          {
            name: 'Usuários',
            icon: 'fas fa-fw fa-user',
            link: '/admin/usuarios'
          }
        ]
      }
    ]

    return {
      toggle,

      items
    }
  }
})
</script>

<style lang="scss" scoped>
.sidebar {
  width: $sidebar-collapsed-width;
  min-height: 100vh;

  transition: width $sidebar-transition-time;
  .nav-item {
    position: relative;
    &:last-child {
      margin-bottom: 1rem;
    }
    .nav-link {
      text-align: center;
      padding: 0.75rem 1rem;
      width: $sidebar-collapsed-width;
      span {
        font-size: 0.65rem;
        display: block;
      }
    }
    &.active {
      .nav-link {
        font-weight: 700;
      }
    }
    // Accordion
    .collapse {
      position: absolute;
      left: calc(#{$sidebar-collapsed-width} + #{$grid-gutter-width} / 2);
      z-index: 1;
      top: 2px;
      // Grow In Animation
      @extend .animated--grow-in !optional;
      .collapse-inner {
        border-radius: $border-radius;
        box-shadow: $box-shadow;
      }
    }
    .collapsing {
      display: none;
      transition: none;
    }
    .collapse,
    .collapsing {
      .collapse-inner {
        padding: 0.5rem 0;
        min-width: 10rem;
        font-size: $dropdown-font-size;
        margin: 0 0 1rem 0;
        .collapse-header {
          margin: 0;
          white-space: nowrap;
          padding: 0.5rem 1.5rem;
          text-transform: uppercase;
          font-weight: 800;
          font-size: 0.65rem;
          color: $gray-500;
        }
        .collapse-item {
          padding: 0.5rem 1rem;
          margin: 0 0.5rem;
          display: block;
          color: $gray-900;
          text-decoration: none;
          border-radius: $border-radius;
          white-space: nowrap;
          &:hover {
            background-color: $gray-200;
          }
          &:active {
            background-color: $gray-300;
          }
          &.active {
            color: $primary;
            font-weight: 700;
          }
        }
      }
    }
  }
  .btn-toggle {
    width: 2.5rem;
    height: 2.5rem;
    text-align: center;
    margin-bottom: 1rem;
    cursor: pointer;
    &::after {
      font-weight: 900;
      content: "\f104";
      font-family: "Font Awesome 5 Free";
      margin-right: 0.1rem;
    }
    &:hover {
      text-decoration: none;
    }
    &:focus {
      outline: none;
    }
  }
  &.toggled {
    width: 0 !important;
    overflow: hidden;
    .btn-toggle::after {
      content: "\f105";
      font-family: "Font Awesome 5 Free";
      margin-left: 0.25rem;
    }
  }
  .sidebar-brand {
    height: $topbar-base-height;
    text-decoration: none;
    font-size: 1rem;
    font-weight: 800;
    padding: 1.5rem 1rem;
    text-align: center;
    text-transform: uppercase;
    letter-spacing: 0.05rem;
    z-index: 1;

    .sidebar-brand-icon i {
      font-size: 2rem;
    }
    .sidebar-brand-text {
      display: none;
    }
  }
  hr.sidebar-divider {
    margin: 0 1rem 1rem;
  }
  .sidebar-heading {
    text-align: center;
    padding: 0 1rem;
    font-weight: 800;
    font-size: 0.65rem;
    @extend .text-uppercase;
  }
}

@include media-breakpoint-up(md) {
  .sidebar {
    width: $sidebar-base-width !important;
    .nav-item {
      // Accordion
      .collapse {
        position: relative;
        left: 0;
        z-index: 1;
        top: 0;
        animation: none;
        .collapse-inner {
          border-radius: 0;
          box-shadow: none;
        }
      }
      .collapsing {
        display: block;
        transition: $transition-collapse;
      }
      .collapse,
      .collapsing {
        margin: 0 1rem;
      }
      .nav-link {
        display: block;
        text-align: left;
        padding: 1rem;
        width: $sidebar-base-width;
        i {
          font-size: 0.85rem;
          margin-right: 0.25rem;
        }
        span {
          font-size: 0.85rem;
          display: inline;
        }
        // Accordion Arrow Icon
        &[data-toggle="collapse"] {
          &::after {
            width: 1rem;
            text-align: center;
            float: right;
            vertical-align: 0;
            border: 0;
            font-weight: 900;
            content: "\f107";
            font-family: "Font Awesome 5 Free";
          }
          &.collapsed::after {
            content: "\f105";
          }
        }
      }
    }
    .sidebar-brand {
      .sidebar-brand-icon i {
        font-size: 2rem;
      }
      .sidebar-brand-text {
        display: inline;
      }
    }
    .sidebar-heading {
      text-align: left;
    }
    &.toggled {
      overflow: visible;
      width: $sidebar-collapsed-width !important;
      transition: width $sidebar-transition-time;
      .nav-item {
        // Accordion
        .collapse {
          position: absolute;
          left: calc(#{$sidebar-collapsed-width} + #{$grid-gutter-width} / 2);
          z-index: 1;
          top: 2px;
          // Grow In Animation for Toggled State
          animation-name: growIn;
          animation-duration: 200ms;
          animation-timing-function: transform cubic-bezier(0.18, 1.25, 0.4, 1),
            opacity cubic-bezier(0, 1, 0.4, 1);
          .collapse-inner {
            box-shadow: $box-shadow;
            border-radius: $border-radius;
          }
        }
        .collapsing {
          display: none;
          transition: none;
        }
        .collapse,
        .collapsing {
          margin: 0;
        }
        &:last-child {
          margin-bottom: 1rem;
        }
        .nav-link {
          text-align: center;
          padding: 0.75rem 1rem;
          width: $sidebar-collapsed-width;
          span {
            font-size: 0.65rem;
            display: block;

            transition: font-size $sidebar-transition-time;
          }
          i {
            margin-right: 0;
          }
          &[data-toggle="collapse"]::after {
            display: none;
          }
        }
      }
      .sidebar-brand {
        .sidebar-brand-icon i {
          font-size: 2rem;
        }
        .sidebar-brand-text {
          display: none;
        }
      }
      .sidebar-heading {
        text-align: center;
      }
    }
  }
}

// Sidebar Color Variants

// Sidebar Light
.sidebar-light {
  .sidebar-brand {
    color: $gray-700;
  }
  hr.sidebar-divider {
    border-top: 1px solid $gray-200;
  }
  .sidebar-heading {
    color: $gray-500;
  }
  .nav-item {
    .nav-link {
      color: $gray-600;
      i {
        color: $gray-400;
      }
      &:active,
      &:focus,
      &:hover {
        color: $gray-700;
        i {
          color: $gray-700;
        }
      }
      // Accordion
      &[data-toggle="collapse"]::after {
        color: $gray-500;
      }
    }
    &.active {
      .nav-link {
        color: $gray-700;
        i {
          color: $gray-700;
        }
      }
    }
  }
  // Color the sidebar toggler
  .btn-toggle {
    background-color: $gray-200;
    &::after {
      color: $gray-500;
    }
    &:hover {
      background-color: $gray-300;
    }
  }
}

// Sidebar Dark
.sidebar-dark {
  .sidebar-brand {
    color: $white;
  }
  hr.sidebar-divider {
    border-top: 1px solid fade-out($white, 0.85);
  }
  .sidebar-heading {
    color: fade-out($white, 0.6);
  }
  .nav-item {
    .nav-link {
      color: fade-out($white, 0.2);
      i {
        color: fade-out($white, 0.7);
      }
      &:active,
      &:focus,
      &:hover {
        color: $white;
        i {
          color: $white;
        }
      }
      // Accordion
      &[data-toggle="collapse"]::after {
        color: fade-out($white, 0.5);
      }
    }
    &.active {
      .nav-link {
        color: $white;
        i {
          color: $white;
        }
      }
    }
  }
  // Color the sidebar toggler
  .btn-toggle {
    background-color: fade-out($white, 0.8);
    &::after {
      color: fade-out($white, 0.5);
    }
    &:hover {
      background-color: fade-out($white, 0.75);
    }
  }
  &.toggled {
    .btn-toggle::after {
      color: fade-out($white, 0.5);
    }
  }
}
</style>
