<template>
  <div class="home">
    <log-out-link />
    <home-contents />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import HomeContents from '@/components/HomeContents.vue'
import LogOutLink from '@/components/LogOutLink.vue'

@Component({
  components: {
    HomeContents,
    LogOutLink
  }
})
export default class Home extends Vue {}
</script>
