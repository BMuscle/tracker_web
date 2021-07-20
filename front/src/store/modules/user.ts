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

interface User {
  email: string
}

@Module({ dynamic: true, store, name: 'user', namespaced: true })
class UserModule extends VuexModule {
  userData: User | null = null

  @Action
  async syncCurrentUser (): Promise<AxiosResponse | AxiosError> {
    try {
      const result = await axios.get('/user')
      this.setCurrentUser(result.data.email)
      return result
    } catch (error) {
      this.clearCurrentUser()
      return error
    }
  }

  @Mutation
  setCurrentUser (email: string) {
    this.userData = { email: email }
  }

  @Mutation
  clearCurrentUser () {
    this.userData = null
  }

  get isLogIn (): boolean {
    return this.userData != null
  }

  get user (): User | null {
    return this.userData
  }
}

export default getModule(UserModule)
