<template>
  <v-main class="log-in">
    <div>ログインページ</div>
    <input name="email" type="text" v-model="email" placeholder="NAME" /><br />
    <input
      name="password"
      type="password"
      v-model="password"
      placeholder="PASSWORD"
    /><br />
    <button id="log_in" @click="logIn()">ログイン</button>
    <toast />
  </v-main>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'
import Toast from '@/components/shared/Toast.vue'

@Component({
  components: {
    Toast
  }
})
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
        if (typeof this.$route.query.redirect === 'string') {
          this.$router.push(this.$route.query.redirect)
        } else {
          this.$router.push('/dashboard')
        }
      })
      .catch(err => {
        console.log(err)
      })
  }
}
</script>
