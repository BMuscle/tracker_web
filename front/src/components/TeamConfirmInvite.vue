<template>
  <div></div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'

@Component
export default class TeamConfirmInvite extends Vue {
  async created (): Promise<void> {
    try {
      const result = await axios.post('/teams/invites/confirm', {
        team: { guid: this.$route.query.guid }
      })
      this.$router.push(`/dashboard/teams/${result.data.id}`)
    } catch (err) {
      this.$router.push('/dashboard')
    }
  }
}
</script>
