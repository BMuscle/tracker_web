<template>
  <div class="home_contents">
    <h1>{{ title }}</h1>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'

@Component
export default class Home extends Vue {
  title = ''
  async getTitle (): Promise<void> {
    const result = await axios.get('/api/homes')
    this.title = result.data.title
  }

  async mounted (): Promise<void> {
    await this.getTitle()
  }
}
</script>

<style scoped></style>
