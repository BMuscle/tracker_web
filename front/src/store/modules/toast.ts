import { Module, VuexModule, Mutation, getModule } from 'vuex-module-decorators'
import store from '..'

type Duration = 'slow' | 'normal' | 'fast'

@Module({ dynamic: true, store, name: 'toast', namespaced: true })
class ToastModule extends VuexModule {
  message = ''
  duration: Duration = 'normal'

  @Mutation
  pushNotice (message: string, duration: Duration = 'normal') {
    this.message = ''
    this.message = message
    this.duration = duration
  }

  get notificationMessage () {
    return this.message
  }

  get notificationDuration () {
    return this.duration
  }
}

export default getModule(ToastModule)
