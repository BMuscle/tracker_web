<template>
  <div class="log-in">
    <div>
      <div>ログインページ</div>
      <input type="text" v-model="email" placeholder="NAME" /><br />
      <input type="password" v-model="password" placeholder="PASSWORD" /><br />
      <button @click="logIn()">LOG_IN</button>
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

  logIn () {
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
