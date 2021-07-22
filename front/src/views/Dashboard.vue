<template>
  <div>
    <v-system-bar app>
      <router-link to="/">{{ $t('home.name') }}</router-link>
      <log-out-button />
    </v-system-bar>

    <v-main>
      <router-view />
      <div class="email">
        {{ email }}
      </div>
      <toast />
    </v-main>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import LogOutButton from '@/components/shared/LogOutButton.vue'
import Toast from '@/components/shared/Toast.vue'
import UserModule from '@/store/modules/user'

@Component({
  components: {
    LogOutButton,
    Toast
  }
})
export default class Dashboard extends Vue {
  email = ''

  async mounted (): Promise<void> {
    if (UserModule.user != null) {
      this.email = UserModule.user.email
    }
  }
}
</script>
