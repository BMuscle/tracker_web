<template>
  <div class="room-groups">
    <v-row class="room-head d-flex align-center" no-gutters>
      <v-col cols="2">
        <v-btn icon @click="toggleGroup">
          <toggle-angle-right :isOpen="isOpenGroup" />
        </v-btn>
      </v-col>
      <v-col cols="6" class="room-title" @click="toggleGroup">
        {{ $t('room_groups.title') }}
      </v-col>
      <v-col cols="2">
        <v-btn icon @click="openCreateRoom" class="open-create-room-button">
          <plus-square :size="14" />
        </v-btn>
      </v-col>
    </v-row>
    <div class="room-body" v-if="isOpenGroup">
      <div v-for="room in rooms" :key="room.id" class="room" link>
        <v-row class="room-name" @click="participateRoom(room.id)" no-gutters>
          <v-col>
            {{ room.name }}
          </v-col>
        </v-row>
        <v-row
          v-for="user in room.users"
          :key="user.id"
          no-gutters
          class="users"
        >
          <v-col class="user-name">
            {{ user.id }}
          </v-col>
        </v-row>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, Emit } from 'vue-property-decorator'
import PlusSquare from '@/components/shared/icons/PlusSquare.vue'
import ToggleAngleRight from '@/components/shared/icons/ToggleAngleRight.vue'
import axios from '@/plugins/axios'
import { Room } from '@/components/RoomsNavigationDrawer.vue'
import TeamModule from '@/store/modules/team'

@Component({
  components: {
    PlusSquare,
    ToggleAngleRight
  }
})
export default class RoomGroups extends Vue {
  @Prop({ type: Array, required: true, default: [] })
  rooms!: Room[]

  isOpenGroup = true

  @Emit('open-create-room')
  openCreateRoom (): true {
    return true
  }

  participateRoom (roomId: number): void {
    if (TeamModule.teamId) {
      axios.post(`/teams/${TeamModule.teamId}/user_in_rooms`, {
        room: { id: roomId }
      })
    }
  }

  toggleGroup (): void {
    this.isOpenGroup = !this.isOpenGroup
  }
}
</script>

<style scoped lang="scss">
.room-groups {
  padding-top: 10px;
  .room-head {
    font-size: 15px;
    .room-title {
      color: #fff;
      cursor: pointer;
      font-weight: 900;
    }
  }
  .room-body {
    .room {
      font-size: 15px;
      padding-left: 50px !important;
      .room-name {
        color: #fff;
        font-weight: 800;
      }
      .users {
        .user-name {
          padding-left: 10px;
          color: #fff;
          font-weight: 600;
        }
      }
    }
  }
}
</style>
