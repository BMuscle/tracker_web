<template>
  <div class="log-out-link">
    <button @click="logOut">
      LogOut
    </button>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'

@Component
export default class Home extends Vue {
  logOut (): void {
    axios.post('/log_out').then(() => {
      this.$router.go(0)
    })
  }
}
</script>

<style scoped></style>
