<template>
  <div>
    <button class="create-team" @click="openCreateTeam" />
    <v-dialog v-model="createTeamDialog" width="500">
      <v-card>
        <v-form @submit.prevent="createTeam" ref="createTeamForm">
          <v-card-title>
            {{ $t('create_team.title') }}
          </v-card-title>
          <v-card-text>
            <v-text-field
              v-model="teamName"
              :rules="[rules.required, rules.rangeString]"
              clearable
              counter
              maxlength="30"
              minlength="4"
              :label="$t('model.team.name')"
            ></v-text-field>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="primary" text type="submit">
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

@Component
export default class CreateTeam extends Vue {
  createTeamDialog = false
  teamName = ''
  rules = {
    required: required,
    rangeString: (value: string): LocaleMessage | boolean => {
      return rangeString(value, 4, 30)
    }
  }

  @Ref('createTeamForm') readonly createTeamForm!: Vue & {
    validate: () => boolean
  }

  async openCreateTeam (): Promise<void> {
    this.teamName = ''
    this.createTeamDialog = true
  }

  @Emit('created-team')
  createdTeam (): true {
    return true
  }

  async createTeam (): Promise<void> {
    if (!this.createTeamForm.validate()) {
      return
    }
    try {
      await axios.post('/teams', { team: { name: this.teamName } })
      this.createdTeam()
    } catch (error) {
      ToastModule.pushNotice({
        message: this.$t('toast.regist_failed'),
        notificationType: 'danger'
      })
    }
    this.createTeamDialog = false
  }
}
</script>

<style scoped lang="scss">
.create-team {
  background-color: #cae4db;
  border-radius: 50%;
  display: inline-block;
  height: 55px;
  margin-bottom: 20px;
  width: 55px;
}
</style>
