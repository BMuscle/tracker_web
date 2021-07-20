<template>
  <div class="user-confirmatino"></div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'

@Component
export default class UserConfirmation extends Vue {
  async confirm (): Promise<void> {
    try {
      await axios.post('/users/confirmation/authenticate', {
        confirmation_token: this.$route.query.confirmation_token
      })
      this.$router.push('/log_in')
    } catch (error) {
      console.log(error.response)
    }
  }

  async created (): Promise<void> {
    if (typeof this.$route.query.confirmation_token === 'string') {
      await this.confirm()
    } else {
    }
  }
}
</script>
