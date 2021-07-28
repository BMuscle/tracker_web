<template>
  <v-navigation-drawer
    id="teams_navigation_drawer"
    width="70"
    absolute
    permanent
    color="#334257"
  >
    <div class="teams">
      <button
        class="team"
        v-for="team in teams"
        :key="team.id"
        @click="visitTeam(team.id)"
      >
        <div class="name">
          {{ team.name }}
        </div>
      </button>
    </div>
    <create-team @created-team="syncTeams()" />
  </v-navigation-drawer>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'
import CreateTeam from './teams_navigation_drawer/CreateTeam.vue'

@Component({
  components: {
    CreateTeam
  }
})
export default class TeamsNavigationDrawer extends Vue {
  teams = []

  visitTeam (teamId: number): void {
    if (this.$route.params.teamId !== teamId.toString()) {
      this.$router.push(`/dashboard/teams/${teamId}`)
    }
  }

  async syncTeams (): Promise<void> {
    const result = await axios.get('/teams')
    this.teams = result.data.teams
  }

  async created (): Promise<void> {
    await this.syncTeams()
  }
}
</script>

<style scoped lang="scss">
.teams-navigation-drawer {
  text-align: center;
}

.teams {
  margin-top: 20px;
  text-align: center;
  .team {
    background-color: gray;
    border-radius: 50%;
    display: inline-block;
    height: 55px;
    margin-bottom: 10px;
    width: 55px;
    .name {
      color: white;
      display: table-cell;
      font-weight: 700;
      height: 55px;
      text-align: center;
      vertical-align: middle;
      width: 55px;
    }
  }
}
</style>
