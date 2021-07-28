import {
  Module,
  VuexModule,
  Mutation,
  Action,
  getModule
} from 'vuex-module-decorators'
import axios from '@/plugins/axios'
import { AxiosResponse, AxiosError } from 'axios'
import store from '..'

export interface Team {
  id: number | null
  name: string | null
  inviteGuid: string | null
  isInviteExpired: boolean
}

@Module({ dynamic: true, store, name: 'team', namespaced: true })
class TeamModule extends VuexModule {
  id: number | null = null
  name: string | null = ''
  inviteGuid: string | null = ''
  isInviteExpired = true

  @Action
  async syncTeam (id: string): Promise<AxiosResponse | AxiosError> {
    try {
      const response = await axios.get(`/teams/${id}`)
      this.setTeam({
        id: response.data.id,
        name: response.data.name,
        inviteGuid: response.data.invite_guid,
        isInviteExpired: response.data.invite_expired
      })
      return response
    } catch (error) {
      return error
    }
  }

  @Mutation
  setTeam (team: Team) {
    this.id = team.id
    this.name = team.name
    this.inviteGuid = team.inviteGuid
    this.isInviteExpired = team.isInviteExpired
  }

  @Mutation
  updateInvite (inviteGuid: string | null) {
    this.inviteGuid = inviteGuid
    this.isInviteExpired = false
  }

  get team (): Team {
    return {
      id: this.id,
      name: this.name,
      inviteGuid: this.inviteGuid,
      isInviteExpired: this.isInviteExpired
    }
  }

  get teamId (): Team['id'] {
    return this.id
  }
}

export default getModule(TeamModule)
