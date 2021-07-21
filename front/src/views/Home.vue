<template>
  <div class="home">
    <public-navigation-bar />
    <v-main>
      <home-contents />
    </v-main>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import HomeContents from '@/components/HomeContents.vue'
import PublicNavigationBar from '@/components/shared/PublicNavigationBar.vue'

@Component({
  components: {
    HomeContents,
    PublicNavigationBar
  }
})
export default class Home extends Vue {}
</script>
