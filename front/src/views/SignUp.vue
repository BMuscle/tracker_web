<template>
  <v-main class="sign-up">
    <div>{{ $t('sign_up.name') }}</div>
    <input
      type="text"
      v-model="email"
      :placeholder="$t('model.user.email')"
    /><br />
    <input
      type="password"
      v-model="password"
      :placeholder="$t('model.user.password')"
    /><br />
    <input
      type="password"
      v-model="passwordConfirmation"
      :placeholder="$t('model.user.password_confirmation')"
    /><br />
    <button @click="signUp()">{{ $t('button.regist') }}</button>
  </v-main>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'
import ToastModule from '@/store/modules/toast'

@Component
export default class SignUp extends Vue {
  email = ''
  password = ''
  passwordConfirmation = ''

  signUp (): void {
    axios
      .post('/sign_up', {
        user: {
          email: this.email,
          password: this.password,
          password_confirmation: this.passwordConfirmation
        }
      })
      .then(() => {
        this.$router.push('/log_in')
        ToastModule.pushNotice({
          message: this.$t('toast.sent_a_verification_email'),
          notificationType: 'info'
        })
      })
      .catch(err => {
        console.log(err.response)
        ToastModule.pushNotice({
          message: this.$t('toast.sign_up_failed'),
          notificationType: 'danger'
        })
      })
  }
}
</script>
