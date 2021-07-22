<template>
  <v-app-bar app color="#334257" id="public_navigation_bar">
    <v-spacer />
    <router-link to="/" v-slot="{ navigate }">
      <v-btn @click="navigate" class="nav-item">
        {{ $t('home.name') }}
      </v-btn>
    </router-link>
    <div v-if="isLoggedIn">
      <router-link to="/dashboard" v-slot="{ navigate }">
        <v-btn @click="navigate" class="nav-item">
          {{ $t('dashboard.name') }}
        </v-btn>
      </router-link>
      <log-out-button class="nav-item" />
    </div>
    <div v-else>
      <router-link to="/log_in" v-slot="{ navigate }">
        <v-btn @click="navigate" class="nav-item">
          {{ $t('log_in.name') }}
        </v-btn>
      </router-link>
      <router-link to="/sign_up" v-slot="{ navigate }">
        <v-btn @click="navigate" class="nav-item">
          {{ $t('sign_up.name') }}
        </v-btn>
      </router-link>
    </div>
  </v-app-bar>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import UserModule from '@/store/modules/user'
import LogOutButton from '@/components/shared/LogOutButton.vue'

@Component({
  components: {
    LogOutButton
  }
})
export default class PublicNavigationBar extends Vue {
  get isLoggedIn (): boolean {
    return UserModule.isLogIn
  }
}
</script>

<style scoped lang="scss">
.nav-item {
  margin-right: 20px;
}
</style>
