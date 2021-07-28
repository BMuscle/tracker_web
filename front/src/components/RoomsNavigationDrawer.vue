<template>
  <v-sheet
    id="rooms_navigation_drawer"
    width="100%"
    height="100%"
    color="#476072"
  >
    <div v-if="!isLoading">
      <v-list class="rooms" dense>
        <v-list-group :value="isRoomOpen" no-action class="room-group">
          <template v-slot:activator>
            <v-list-item-title class="room-group-title">
              ルーム
            </v-list-item-title>
            <plus-square :size="18" />
          </template>
          <v-list-item v-for="room in rooms" :key="room.id" class="room" link>
            <v-list-item-title class="name" v-text="room.name">
            </v-list-item-title>
          </v-list-item>
        </v-list-group>
      </v-list>
    </div>
  </v-sheet>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator'
import axios from '@/plugins/axios'
import { Route } from 'vue-router'
import PlusSquare from '@/components/shared/icons/PlusSquare.vue'

@Component({
  components: {
    PlusSquare
  }
})
export default class RoomsNavigationDrawer extends Vue {
  rooms = []
  isLoading = true
  isRoomOpen = true

  async syncRooms (teamId: string): Promise<void> {
    const result = await axios.get(`/teams/${teamId}/rooms`)
    this.rooms = result.data.rooms
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

.rooms {
  .room-group {
    .room-group-title {
      color: #fff;
      font-weight: 900;
    }
    .room {
      padding-left: 30px !important;
      .name {
        color: #fff;
        font-weight: 800;
      }
    }
  }
}
</style>
