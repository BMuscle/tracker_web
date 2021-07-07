<template>
  <div class="home">
    <home-contents />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import HomeContents from '@/components/HomeContents.vue'

@Component({
  components: {
    HomeContents
  }
})
export default class Home extends Vue {}
</script>
