<template>
  <div>
    <v-system-bar app>
      <router-link to="/">{{ $t('home.name') }}</router-link>
      <log-out-button />
    </v-system-bar>

    <v-app-bar app clipped-right> </v-app-bar>

    <v-navigation-drawer app width="300" permanent color="gray">
      <teams-navigation-drawer />
      <rooms-navigation-drawer />
    </v-navigation-drawer>

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
import TeamsNavigationDrawer from '@/components/TeamsNavigationDrawer.vue'
import RoomsNavigationDrawer from '@/components/RoomsNavigationDrawer.vue'
import Toast from '@/components/shared/Toast.vue'
import UserModule from '@/store/modules/user'

@Component({
  components: {
    LogOutButton,
    TeamsNavigationDrawer,
    RoomsNavigationDrawer,
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
