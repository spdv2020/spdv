<template>
  <h1 class="h3 mb-0 text-gray-800">{{ name }}</h1>

  <slot name="right"></slot>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'HeadingDefault',
  props: {
    name: String
  }
})
</script>
