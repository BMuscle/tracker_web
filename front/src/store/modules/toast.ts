import { Module, VuexModule, Mutation, getModule } from 'vuex-module-decorators'
import store from '..'
import { TranslateResult } from 'vue-i18n'

type Duration = 'slow' | 'normal' | 'fast'
type NotificationType = 'success' | 'info' | 'danger' | 'warning'

const NotificationType = {
  success: '#689F38',
  info: '#00ACC1',
  danger: '#D32F2F',
  warning: '#F9A825'
} as const

@Module({ dynamic: true, store, name: 'toast', namespaced: true })
class ToastModule extends VuexModule {
  message: TranslateResult = ''
  duration: Duration = 'normal'
  color: typeof NotificationType[keyof typeof NotificationType] =
    NotificationType.info

  @Mutation
  pushNotice (pushData: {
    message: TranslateResult
    notificationType: NotificationType
    duration?: Duration
  }) {
    this.message = ''
    this.message = pushData.message
    this.color = NotificationType[pushData.notificationType]
    this.duration = pushData.duration || 'normal'
  }

  get notificationMessage () {
    return this.message
  }

  get notificationDuration () {
    return this.duration
  }

  get notificationColor () {
    return this.color
  }
}

export default getModule(ToastModule)
