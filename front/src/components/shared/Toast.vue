<template>
  <v-snackbar v-model="snackbar" :timeout="timeout">
    {{ message }}
  </v-snackbar>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import ToastModule from '@/store/modules/toast'

@Component
export default class Toast extends Vue {
  snackbar = false
  timeout = this.normal

  get slow (): number {
    return 5000
  }

  get normal (): number {
    return 4000
  }

  get fast (): number {
    return 3000
  }

  get message (): string {
    const message = ToastModule.notificationMessage
    if (message === '') {
      return ''
    }
    switch (ToastModule.notificationDuration) {
      case 'slow':
        this.timeout = this.slow
        break
      case 'normal':
        this.timeout = this.normal
        break
      case 'fast':
        this.timeout = this.fast
        break
    }
    this.snackbar = true
    return message
  }
}
</script>

<style></style>
