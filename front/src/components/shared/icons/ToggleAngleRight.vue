<template>
  <v-icon
    color="#ccc"
    :size="size"
    :class="{ 'toggle-angle-right': true, 'toggle-angle-right-open': isOpen }"
  >
    fas fa-angle-right
  </v-icon>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator'

@Component
export default class PlusSquare extends Vue {
  @Prop({ type: Number, default: 20 })
  size!: number

  @Prop({ type: Boolean, required: true })
  isOpen!: boolean
}
</script>

<style scoped lang="scss">
.toggle-angle-right {
  &-open {
    transform: rotate(+90deg);
  }
}
</style>
