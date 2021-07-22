<template>
  <v-snackbar v-model="snackbar" :timeout="timeout" :color="color">
    {{ message }}
  </v-snackbar>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import ToastModule from '@/store/modules/toast'
import { TranslateResult } from 'vue-i18n'

@Component
export default class Toast extends Vue {
  snackbar = false
  timeout = this.normal
  color = ''

  get slow (): number {
    return 5000
  }

  get normal (): number {
    return 4000
  }

  get fast (): number {
    return 3000
  }

  get message (): TranslateResult {
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
    this.color = ToastModule.notificationColor
    this.snackbar = true
    return message
  }
}
</script>
