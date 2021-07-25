<template>
  <div>
    <div v-if="!isLoading">
      <div>id: {{ id }}</div>
      <div>name: {{ name }}</div>
      <div>expired? {{ expired }}</div>
      <demo-create-invite :teamId="$route.params.id" />
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import DemoCreateInvite from '@/components/team/DemoCreateInvite.vue'
import axios from '@/plugins/axios'
import { NavigationGuardNext, Route } from 'vue-router'

@Component({
  components: {
    DemoCreateInvite
  }
})
export default class TeamDashboard extends Vue {
  id = null
  name = ''
  expired = null
  isLoading = true

  async syncTeam (): Promise<void> {
    const response = await axios.get(`/teams/${this.$route.params.id}`)
    this.id = response.data.id
    this.name = response.data.name
    this.expired = response.data.invite_expired
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
