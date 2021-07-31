<template>
  <v-sheet
    id="rooms_navigation_drawer"
    width="100%"
    height="100%"
    color="#476072"
  >
    <div v-if="!isLoading">
      <room-groups
        :rooms="orderedRooms"
        @open-create-room="createRoomComponent.openCreateRoom()"
      />
    </div>
    <create-room ref="createRoomComponent" />
  </v-sheet>
</template>

<script lang="ts">
import { Component, Vue, Watch, Ref } from 'vue-property-decorator'
import axios from '@/plugins/axios'
import { Route } from 'vue-router'
import RoomGroups from './rooms_navigation_drawer/RoomGroups.vue'
import CreateRoom from './rooms_navigation_drawer/CreateRoom.vue'
import { cable } from '@/plugins/actioncable'
import { Subscription } from '@rails/actioncable'

interface User {
  id: number
}

export interface Room {
  id: number
  name: string
  users: User[]
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
  subscription: Subscription | null = null

  get orderedRooms (): Room[] {
    return this.rooms.sort((a, b) => {
      return a.name > b.name ? 1 : -1
    })
  }

  async syncRooms (teamId: string): Promise<void> {
    const result = await axios.get(`/teams/${teamId}/rooms`)
    this.rooms = result.data.rooms
  }

  reloadRooms (): void {
    const teamId = this.$route.params.teamId
    if (teamId) {
      this.syncRooms(teamId)
    }
  }

  @Watch('$route')
  onChangeRoute (to: Route, from: Route): void {
    const toTeamId = to.params.teamId
    const fromTeamId = from.params.teamId
    if (toTeamId && fromTeamId && toTeamId === fromTeamId) {
      return
    }
    if (toTeamId) {
      this.isLoading = true
      this.subscribe(toTeamId)
      this.isLoading = false
    }
  }

  async created (): Promise<void> {
    const teamId = this.$route.params.teamId
    if (teamId) {
      this.subscribe(teamId)
      this.isLoading = false
    }
  }

  subscribe (teamId: string | number): void {
    this.unsubscribe()
    const subscription = cable.subscriptions.create(
      { channel: 'UserInRoomChannel', team_id: teamId },
      {
        initialized: () => {
          console.log('init')
        },
        connected: () => {
          console.log('connected')
          this.reloadRooms()
        },
        disconnected () {
          console.log('disconnected')
        },
        received: data => {
          console.log('received')
          if (
            data.message === 'participated' ||
            data.message === 'leaved' ||
            data.message === 'created_room'
          ) {
            this.rooms = data.rooms
          }
        },
        rejected () {
          console.log('reject')
        }
      }
    )
    this.subscription = subscription
  }

  beforeDestroy (): void {
    this.unsubscribe()
  }

  unsubscribe (): void {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
  }
}
</script>

<style scoped lang="scss">
#rooms_navigation_drawer {
  padding-left: 70px;
}
</style>
