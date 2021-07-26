<template>
  <div>
    <v-btn @click="updateInvite">
      招待URLの作成
    </v-btn>
    <v-row>
      <v-col cols="2" />
      <v-col cols="5">
        <v-text-field
          label="招待URL"
          readonly
          outlined
          :value="inviteUrl"
          width="300"
          height="56"
        />
      </v-col>
      <v-col cols="3">
        <v-btn
          block
          depressed
          height="56"
          v-clipboard:copy="inviteUrl"
          v-clipboard:success="successfulCopy"
          v-clipboard:error="unsuccessfulCopy"
        >
          コピー
        </v-btn>
      </v-col>
    </v-row>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'
import ToastModule from '@/store/modules/toast'
import TeamModule from '@/store/modules/team'

@Component
export default class DemoCreateInvite extends Vue {
  get inviteUrl (): string | null {
    const inviteGuid = TeamModule.team.inviteGuid
    if (inviteGuid == null) {
      return null
    } else {
      return `${process.env.VUE_APP_FRONT_END_URL}/teams/invites/confirm?guid=${inviteGuid}`
    }
  }

  updateInvite (): void {
    axios.put(`/teams/invites/${TeamModule.team.id}`).then(response => {
      TeamModule.updateInvite(response.data.invite_guid)
    })
  }

  successfulCopy (): void {
    ToastModule.pushNotice({
      message: this.$t('toast.successful_copy'),
      notificationType: 'success'
    })
  }

  unsuccessfulCopy (): void {
    ToastModule.pushNotice({
      message: this.$t('toast.unsuccessful_copy'),
      notificationType: 'warning'
    })
  }
}
</script>
