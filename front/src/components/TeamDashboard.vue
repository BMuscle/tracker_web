<template>
  <div id="team_dashboard">
    <div v-if="!isLoading">
      <div>id: {{ team.id }}</div>
      <div>name: {{ team.name }}</div>
      <div>expired? {{ team.isInviteExpired }}</div>
      <demo-create-invite />
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import DemoCreateInvite from '@/components/team/DemoCreateInvite.vue'
import { NavigationGuardNext, Route } from 'vue-router'
import TeamModule, { Team } from '@/store/modules/team'

@Component({
  components: {
    DemoCreateInvite
  }
})
export default class TeamDashboard extends Vue {
  isLoading = true

  async syncTeam (): Promise<void> {
    TeamModule.syncTeam(this.$route.params.id)
  }

  get team (): Team {
    return TeamModule.team
  }

  async beforeRouteUpdate (
    _to: Route,
    _from: Route,
    next: NavigationGuardNext<Vue>
  ): Promise<void> {
    this.isLoading = true
    next()
    await this.syncTeam()
    this.isLoading = false
  }

  async created (): Promise<void> {
    await this.syncTeam()
    this.isLoading = false
  }
}
</script>
