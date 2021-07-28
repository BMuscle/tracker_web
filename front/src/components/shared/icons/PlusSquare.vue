<template>
  <v-icon color="#ccc" :size="size">
    far fa-plus-square
  </v-icon>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator'

@Component
export default class PlusSquare extends Vue {
  @Prop({ type: Number, default: 20 })
  size!: number
}
</script>
