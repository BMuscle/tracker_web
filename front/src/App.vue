<template>
  <v-app>
    <v-system-bar app>
      <router-link to="/">Home</router-link> |
      <router-link to="/log_in">LogIn</router-link> |
      <router-link to="/sign_up">SignUp</router-link> |
      <router-link to="/about">About</router-link>
    </v-system-bar>

    <v-main>
      <router-view />
    </v-main>
  </v-app>
</template>
