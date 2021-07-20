<template>
  <div class="home-contents">
    <h1 class="title">{{ title }}</h1>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'

@Component
export default class Home extends Vue {
  title = ''
  async getTitle (): Promise<void> {
    const result = await axios.get('/homes')
    this.title = result.data.title
  }

  async mounted (): Promise<void> {
    await this.getTitle()
  }
}
</script>

<style scoped lang="scss">
.home-contents {
  .title {
    color: #f00;
    font-size: 1.5em;
  }
}
</style>
