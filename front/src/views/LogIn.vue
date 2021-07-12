<template>
  <div class="log-in">
    <div>
      <div>ログインページ</div>
      <input
        name="email"
        type="text"
        v-model="email"
        placeholder="NAME"
      /><br />
      <input
        name="password"
        type="password"
        v-model="password"
        placeholder="PASSWORD"
      /><br />
      <button id="log_in" @click="logIn()">LOG_IN</button>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'

@Component
export default class LogIn extends Vue {
  email = ''
  password = ''

  logIn (): void {
    axios
      .post('/log_in', {
        user: {
          email: this.email,
          password: this.password
        }
      })
      .then(() => {
        this.$router.push('/')
      })
      .catch(err => {
        console.log(err)
      })
  }
}
</script>
