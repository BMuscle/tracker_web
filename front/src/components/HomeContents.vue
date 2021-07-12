<template>
  <div class="home-contents">
    <h1>{{ title }}</h1>
    <div class="email">{{ email }}</div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import axios from '@/plugins/axios'

@Component
export default class Home extends Vue {
  title = ''
  email = ''
  async getTitle (): Promise<void> {
    const result = await axios.get('/homes')
    this.title = result.data.title
  }

  async getCurrentUser (): Promise<void> {
    try {
      const result = await axios.get('/user')
      this.email = result.data.email
    } catch (error) {}
  }

  async mounted (): Promise<void> {
    await this.getTitle()
    await this.getCurrentUser()
  }
}
</script>

<style scoped></style>
