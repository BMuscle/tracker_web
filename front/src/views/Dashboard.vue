<template>
  <div>
    <v-system-bar app>
      <router-link to="/">Home</router-link>
      <log-out-button />
    </v-system-bar>

    <v-main>
      <router-view />
      <div class="email">
        {{ email }}
      </div>
    </v-main>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import LogOutButton from '@/components/shared/LogOutButton.vue'
import UserModule from '@/store/modules/user'

@Component({
  components: {
    LogOutButton
  }
})
export default class Dashboard extends Vue {
  // ログインしている場合にアクセスできるメイン画面
  email = ''

  async mounted (): Promise<void> {
    if (UserModule.user != null) {
      this.email = UserModule.user.email
    }
  }
}
</script>
