<template>
  <div>
    <Admin :title="title" :version="version">
      <router-view v-slot="{ Component }">
        <transition name="slide-fade">
          <component :is="Component" />
        </transition>
      </router-view>
    </Admin>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

import Admin from '@/components/admin/Admin.vue'

export default defineComponent({
  name: 'AdminIndex',
  components: {
    Admin
  },
  props: {
    title: String,
    version: String
  }
})
</script>
