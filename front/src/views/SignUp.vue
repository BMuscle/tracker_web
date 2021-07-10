<template>
  <div class="sign-up">
    <div>
      <div>サインアップページ</div>
      <input type="text" v-model="email" placeholder="EMAIL" /><br />
      <input type="password" v-model="password" placeholder="PASSWORD" /><br />
      <input
        type="password"
        v-model="passwordConfirimation"
        placeholder="PASSWORD_CONFIRIMATION"
      /><br />
      <button @click="signUp()">SIGN_UP</button>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'

@Component
export default class SignUp extends Vue {
  email = ''
  password = ''
  passwordConfirimation = ''

  signUp (): void {
    axios
      .post('/sign_up', {
        user: {
          email: this.email,
          password: this.password,
          password_confirimation: this.passwordConfirimation
        }
      })
      .then(() => {
        this.$router.push('/log_in')
      })
      .catch(err => {
        console.log(err.response)
      })
  }
}
</script>
