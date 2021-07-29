<template>
  <v-sheet
    id="rooms_navigation_drawer"
    width="100%"
    height="100%"
    color="#476072"
  >
    <div v-if="!isLoading">
      <room-groups
        :rooms="rooms"
        @open-create-room="createRoomComponent.openCreateRoom()"
      />
    </div>
    <create-room @created-room="createdRoom()" ref="createRoomComponent" />
  </v-sheet>
</template>

<script lang="ts">
import { Component, Vue, Watch, Ref } from 'vue-property-decorator'
import axios from '@/plugins/axios'
import { Route } from 'vue-router'
import RoomGroups from './rooms_navigation_drawer/RoomGroups.vue'
import CreateRoom from './rooms_navigation_drawer/CreateRoom.vue'

export interface Room {
  id: number
  name: string
}

@Component({
  components: {
    RoomGroups,
    CreateRoom
  }
})
export default class RoomsNavigationDrawer extends Vue {
  rooms: Room[] = []
  isLoading = true
  isRoomOpen = true
  @Ref('createRoomComponent') readonly createRoomComponent!: Vue

  async syncRooms (teamId: string): Promise<void> {
    const result = await axios.get(`/teams/${teamId}/rooms`)
    this.rooms = result.data.rooms
  }

  createdRoom (): void {
    const teamId = this.$route.params.teamId
    if (teamId) {
      this.syncRooms(teamId)
    }
  }

  @Watch('$route')
  async onChangeRoute (to: Route, from: Route): Promise<void> {
    const toTeamId = to.params.teamId
    const fromTeamId = from.params.teamId
    if (toTeamId && fromTeamId && toTeamId === fromTeamId) {
      return
    }
    if (toTeamId) {
      this.isLoading = true
      await this.syncRooms(toTeamId)
      this.isLoading = false
    }
  }

  async created (): Promise<void> {
    const teamId = this.$route.params.teamId
    if (teamId) {
      await this.syncRooms(teamId)
    }
    this.isLoading = false
  }
}
</script>

<style scoped lang="scss">
#rooms_navigation_drawer {
  padding-left: 70px;
}
</style>
