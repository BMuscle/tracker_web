<template>
  <div></div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'
import ToastModule from '@/store/modules/toast'
import { AxiosResponse } from 'axios'

@Component
export default class TeamConfirmInvite extends Vue {
  pushNoticeSuccess (already: boolean): void {
    const message = already
      ? 'toast.participate_already'
      : 'toast.participate_success'
    ToastModule.pushNotice({
      message: this.$t(message),
      notificationType: 'success'
    })
  }

  pushNoticeFailed (response: AxiosResponse | undefined): void {
    let message = ''
    if (response) {
      message = response.data.expired
        ? 'toast.participate_expired'
        : 'toast.participate_failed'
    } else {
      message = 'toast.participate_failed'
    }
    ToastModule.pushNotice({
      message: this.$t(message),
      notificationType: 'danger'
    })
  }

  async created (): Promise<void> {
    try {
      const result = await axios.post('/teams/invites/confirm', {
        team: { guid: this.$route.query.guid }
      })
      this.$router.push(`/dashboard/teams/${result.data.id}`)
      this.pushNoticeSuccess(result.data.already)
    } catch (err) {
      this.$router.push('/dashboard')
      this.pushNoticeFailed(err.response)
    }
  }
}
</script>
