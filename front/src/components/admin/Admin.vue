<template>
  <!-- Page Wrapper -->
  <div id="wrapper">
    <Sidebar :title="title" :version="version" v-model:open="open" />

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

      <!-- Main Content -->
      <div id="content">

        <!-- Topbar -->
        <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 fixed-top shadow" :class="{ 'collapsed': !open }">

          <!-- Sidebar Toggle (Topbar) -->
          <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
            <i class="fa fa-bars"></i>
          </button>

          <!-- Topbar Search -->
          <form class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
            <div class="input-group">
              <input type="text" class="form-control bg-light border-0 small" placeholder="Search for..." aria-label="Search" aria-describedby="basic-addon2">
              <div class="input-group-append">
                <button class="btn btn-primary" type="button">
                  <i class="fas fa-search fa-sm"></i>
                </button>
              </div>
            </div>
          </form>

          <!-- Topbar Navbar -->
          <ul class="navbar-nav ml-auto">

            <!-- Nav Item - Search Dropdown (Visible Only XS) -->
            <li class="nav-item dropdown no-arrow d-sm-none">
              <a class="nav-link dropdown-toggle" href="#" id="searchDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fas fa-search fa-fw"></i>
              </a>
              <!-- Dropdown - Messages -->
              <div class="dropdown-menu dropdown-menu-right p-3 shadow animated--grow-in" aria-labelledby="searchDropdown">
                <form class="form-inline mr-auto w-100 navbar-search">
                  <div class="input-group">
                    <input type="text" class="form-control bg-light border-0 small" placeholder="Search for..." aria-label="Search" aria-describedby="basic-addon2">
                    <div class="input-group-append">
                      <button class="btn btn-primary" type="button">
                        <i class="fas fa-search fa-sm"></i>
                      </button>
                    </div>
                  </div>
                </form>
              </div>
            </li>

            <!-- Nav Item - Alerts -->
            <li class="nav-item dropdown no-arrow mx-1">
              <a class="nav-link dropdown-toggle" href="#" id="alertsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fas fa-bell fa-fw"></i>
                <!-- Counter - Alerts -->
                <span class="badge badge-danger badge-counter">3+</span>
              </a>
              <!-- Dropdown - Alerts -->
              <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="alertsDropdown">
                <h6 class="dropdown-header">
                  Alerts Center
                </h6>
                <a class="dropdown-item d-flex align-iteml-center" href="#">
                  <div class="mr-3">
                    <div class="icon-circle bg-primary">
                      <i class="fas fa-file-alt text-white"></i>
                    </div>
                  </div>
                  <div>
                    <div class="small text-gray-500">December 12, 2019</div>
                    <span class="font-weight-bold">A new monthly report is ready to download!</span>
                  </div>
                </a>
                <a class="dropdown-item d-flex align-iteml-center" href="#">
                  <div class="mr-3">
                    <div class="icon-circle bg-success">
                      <i class="fas fa-donate text-white"></i>
                    </div>
                  </div>
                  <div>
                    <div class="small text-gray-500">December 7, 2019</div>
                    $290.29 has been deposited into your account!
                  </div>
                </a>
                <a class="dropdown-item d-flex align-iteml-center" href="#">
                  <div class="mr-3">
                    <div class="icon-circle bg-warning">
                      <i class="fas fa-exclamation-triangle text-white"></i>
                    </div>
                  </div>
                  <div>
                    <div class="small text-gray-500">December 2, 2019</div>
                    Spending Alert: We've noticed unusually high spending for your account.
                  </div>
                </a>
                <a class="dropdown-item text-center small text-gray-500" href="#">Show All Alerts</a>
              </div>
            </li>

            <div class="topbar-divider d-none d-sm-block"></div>

            <!-- Nav Item - User Information -->
            <li class="nav-item dropdown no-arrow">
              <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <span class="mr-2 d-none d-lg-inline text-gray-600 small">Valerie Luna</span>
                <img class="img-profile rounded-circle" src="https://source.unsplash.com/QAB-WJcbgJk/60x60">
              </a>
              <!-- Dropdown - User Information -->
              <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
                <a class="dropdown-item" href="#">
                  <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                  Profile
                </a>
                <a class="dropdown-item" href="#">
                  <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400"></i>
                  Settings
                </a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">
                  <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                  Logout
                </a>
              </div>
            </li>

          </ul>

        </nav>
        <!-- End of Topbar -->

        <!-- Begin Page Content -->
        <div class="container-fluid content">
          <slot></slot>
        </div>
        <!-- /.container-fluid -->

      </div>
      <!-- End of Main Content -->

      <!-- Footer -->
      <footer class="sticky-footer bg-white">
        <div class="container my-auto">
          <div class="copyright text-center my-auto">
            <span>Copyright &copy; {{ title }} {{ (new Date()).getFullYear() }}</span>
          </div>
        </div>
      </footer>
      <!-- End of Footer -->

    </div>
    <!-- End of Content Wrapper -->

  </div>
  <!-- End of Page Wrapper -->

  <!-- Scroll to Top Button-->
  <a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
  </a>

  <!-- Logout Modal -->
  <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
          <button class="close" type="button" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
        <div class="modal-footer">
          <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
          <a class="btn btn-primary" href="login.html">Logout</a>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'

import Sidebar from './Sidebar.vue'

export default defineComponent({
  name: 'Admin',
  components: {
    Sidebar
  },

  props: {
    title: String,
    version: String
  },

  setup () {
    const open = ref(true)

    return {
      open
    }
  }
})
</script>

<style lang="scss" scoped>
.content {
  margin-top: calc(#{$topbar-base-height} + 2.5rem);
}
// Topbar
.topbar {
  height: $topbar-base-height;
  left: $sidebar-base-width;

  transition: left $sidebar-transition-time;

  &.collapsed {
    left: $sidebar-collapsed-width;
  }

  #sidebarToggleTop {
    height: 2.5rem;
    width: 2.5rem;
    &:hover {
      background-color: $gray-200;
    }
    &:active {
      background-color: $gray-300;
    }
  }
  .navbar-search {
    width: 25rem;
    input {
      font-size: 0.85rem;
      height: auto;
    }
  }
  .topbar-divider {
    width: 0;
    border-right: 1px solid $border-color;
    height: calc(#{$topbar-base-height} - 2rem);
    margin: auto 1rem;
  }
  .nav-item {
    .nav-link {
      height: $topbar-base-height;
      display: flex;
      align-items: center;
      padding: 0 0.75rem;
      &:focus {
        outline: none;
      }
    }
    &:focus {
      outline: none;
    }
  }
  .dropdown {
    position: static;
    .dropdown-menu {
      width: calc(100% - #{$grid-gutter-width});
      right: $grid-gutter-width / 2;
    }
  }
  .dropdown-list {
    padding: 0;
    border: none;
    overflow: hidden;
    .dropdown-header {
      background-color: $primary;
      border: 1px solid $primary;
      padding-top: 0.75rem;
      padding-bottom: 0.75rem;
      color: $white;
    }
    .dropdown-item {
      white-space: normal;
      padding-top: 0.5rem;
      padding-bottom: 0.5rem;
      border-left: 1px solid $border-color;
      border-right: 1px solid $border-color;
      border-bottom: 1px solid $border-color;
      line-height: 1.3rem;
      .dropdown-list-image {
        position: relative;
        height: 2.5rem;
        width: 2.5rem;
        img {
          height: 2.5rem;
          width: 2.5rem;
        }
        .status-indicator {
          background-color: $gray-200;
          height: 0.75rem;
          width: 0.75rem;
          border-radius: 100%;
          position: absolute;
          bottom: 0;
          right: 0;
          border: .125rem solid $white;
        }
      }
      .text-truncate {
        max-width: 10rem;
      }
      &:active {
        background-color: $gray-200;
        color: $gray-900;
      }
    }
  }
  @include media-breakpoint-up(sm) {
    .dropdown {
      position: relative;
      .dropdown-menu {
        width: auto;
        right: 0;
      }
    }
    .dropdown-list {
      width: 20rem !important;
      .dropdown-item {
        .text-truncate {
          max-width: 13.375rem;
        }
      }
    }
  }
}

.topbar.navbar-dark {
  .navbar-nav {
    .nav-item {
      .nav-link {
        color: fade-out($white, 0.2);
        &:hover {
          color: $white;
        }
        &:active {
          color: $white;
        }
      }
    }
  }
}

.topbar.navbar-light {
  .navbar-nav {
    .nav-item {
      .nav-link {
        color: $gray-400;
        &:hover {
          color: $gray-500;
        }
        &:active {
          color: $gray-600;
        }
      }
    }
  }
}
</style>
