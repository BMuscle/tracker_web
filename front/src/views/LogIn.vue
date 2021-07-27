<template>
  <v-main class="log-in">
    <div>{{ $t('log_in.name') }}</div>
    <input
      name="email"
      type="text"
      v-model="email"
      :placeholder="$t('model.user.email')"
    /><br />
    <input
      name="password"
      type="password"
      v-model="password"
      :placeholder="$t('model.user.password')"
    /><br />
    <button id="log_in" @click="logIn()">{{ $t('log_in.name') }}</button>
    <toast />
  </v-main>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'
import Toast from '@/components/shared/Toast.vue'
import ToastModule from '@/store/modules/toast'

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
      .catch(() => {
        ToastModule.pushNotice({
          message: this.$t('toast.log_in_failed'),
          notificationType: 'danger'
        })
      })
  }
}
</script>
