<template>
  <div id="create_room">
    <v-dialog v-model="createRoomDialog" width="500">
      <v-card>
        <v-form
          @submit.prevent="createRoom"
          ref="createRoomForm"
          id="create_room_form"
        >
          <v-card-title>
            {{ $t('create_room.title') }}
          </v-card-title>
          <v-card-text>
            <v-text-field
              v-model="roomName"
              :rules="[rules.required, rules.rangeString]"
              clearable
              counter
              maxlength="30"
              minlength="1"
              :label="$t('model.room.name')"
              name="room_name"
            ></v-text-field>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn
              color="primary"
              text
              type="submit"
              class="create-room-submit"
            >
              {{ $t('button.regist') }}
            </v-btn>
          </v-card-actions>
        </v-form>
      </v-card>
    </v-dialog>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Ref, Emit } from 'vue-property-decorator'
import axios from '@/plugins/axios'
import { required, rangeString } from '@/utils/validations'
import { LocaleMessage } from 'vue-i18n'
import ToastModule from '@/store/modules/toast'
import TeamModule from '@/store/modules/team'

@Component
export default class CreateRoom extends Vue {
  createRoomDialog = false
  roomName = ''
  rules = {
    required: required,
    rangeString: (value: string): LocaleMessage | boolean => {
      return rangeString(value, 1, 30)
    }
  }

  @Ref('createRoomForm') readonly createRoomForm!: Vue & {
    validate: () => boolean
  }

  openCreateRoom (): void {
    this.roomName = ''
    this.createRoomDialog = true
  }

  @Emit('created-room')
  createdRoom (): true {
    return true
  }

  async createRoom (): Promise<void> {
    if (!this.createRoomForm.validate()) {
      return
    }
    try {
      await axios.post(`/teams/${TeamModule.teamId}/rooms`, {
        room: { name: this.roomName }
      })
      this.createdRoom()
    } catch (error) {
      ToastModule.pushNotice({
        message: this.$t('toast.regist_failed'),
        notificationType: 'danger'
      })
    } finally {
      this.createRoomDialog = false
    }
  }
}
</script>
