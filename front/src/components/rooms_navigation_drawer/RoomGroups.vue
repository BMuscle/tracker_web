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
        <v-btn icon @click="openCreateRoom">
          <plus-square :size="14" />
        </v-btn>
      </v-col>
    </v-row>
    <div class="room-body" v-if="isOpenGroup">
      <v-row v-for="room in rooms" :key="room.id" class="room" link>
        <div class="name" v-text="room.name"></div>
      </v-row>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, Emit } from 'vue-property-decorator'
import PlusSquare from '@/components/shared/icons/PlusSquare.vue'
import ToggleAngleRight from '@/components/shared/icons/ToggleAngleRight.vue'
import { Room } from '@/components/RoomsNavigationDrawer.vue'

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
    margin-top: 10px;
    .room {
      font-size: 15px;
      padding-left: 60px !important;
      .name {
        color: #fff;
        font-weight: 800;
      }
    }
  }
}
</style>
