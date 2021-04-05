<template>
  <!-- Page Heading -->
  <div class="d-sm-flex align-item-center justify-content-between mb-4">
    <slot name="heading"></slot>
  </div>

  <!-- Content -->
  <slot></slot>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'AdminBody'
})
</script>
