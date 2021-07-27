<template>
  <v-btn @click="logOut" id="log_out_button">
    {{ $t('word.log_out') }}
  </v-btn>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'

@Component
export default class LogOutButton extends Vue {
  logOut (): void {
    axios.post('/log_out').then(() => {
      this.$router.push('/').catch(() => {
        this.$router.go(0)
      })
    })
  }
}
</script>
