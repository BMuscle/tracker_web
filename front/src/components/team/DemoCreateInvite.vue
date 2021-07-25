<template>
  <div>
    <v-btn @click="updateInvite">
      招待URLの作成
    </v-btn>
    <div>招待URL: {{ inviteUrl }}</div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator'
import axios from '@/plugins/axios'

@Component
export default class DemoCreateInvite extends Vue {
  inviteGuid = null

  @Prop({ required: true }) teamId!: number

  get inviteUrl (): string | null {
    if (this.inviteGuid == null) {
      return null
    } else {
      return `${process.env.VUE_APP_FRONT_END_URL}/teams/invites/confirm?guid=${this.inviteGuid}`
    }
  }

  updateInvite (): void {
    axios.put(`/teams/invites/${this.teamId}`).then(response => {
      this.inviteGuid = response.data.invite_guid
    })
  }
}
</script>
