<template>
  <div class="user-confirmatino"></div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'
import ToastModule from '@/store/modules/toast'

@Component
export default class UserConfirmation extends Vue {
  async confirm (): Promise<void> {
    try {
      await axios.post('/users/confirmation/authenticate', {
        confirmation_token: this.$route.query.confirmation_token
      })
      ToastModule.pushNotice({
        message: this.$t('toast.confirm_success'),
        notificationType: 'success'
      })
      this.$router.push('/log_in')
    } catch (error) {
      ToastModule.pushNotice({
        message: this.$t('toast.confirm_failed'),
        notificationType: 'danger'
      })
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
