<template>
  <v-main class="sign-up">
    <div>サインアップページ</div>
    <input type="text" v-model="email" placeholder="EMAIL" /><br />
    <input type="password" v-model="password" placeholder="PASSWORD" /><br />
    <input
      type="password"
      v-model="passwordConfirmation"
      placeholder="PASSWORD_CONFIRMATION"
    /><br />
    <button @click="signUp()">サインアップ</button>
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
        ToastModule.pushNotice('認証メールを送信しました。ご確認下さい。')
      })
      .catch(err => {
        console.log(err.response)
      })
  }
}
</script>
