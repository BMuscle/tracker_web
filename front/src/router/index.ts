import Vue from 'vue'
import VueRouter, { RouteConfig } from 'vue-router'
import Home from '../views/Home.vue'
import Login from '../views/LogIn.vue'
import SignUp from '../views/SignUp.vue'
import UserConfirmation from '../views/UserConfirmation.vue'

Vue.use(VueRouter)

const routes: Array<RouteConfig> = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/log_in',
    name: 'LogIn',
    component: Login
  },
  {
    path: '/sign_up',
    name: 'SignUp',
    component: SignUp
  },
  {
    path: '/users/confirmation',
    name: 'UserConfirmation',
    component: UserConfirmation
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
