import Vue from 'vue'
import VueRouter, { RouteConfig } from 'vue-router'
import Home from '../views/Home.vue'
import Login from '../views/LogIn.vue'
import SignUp from '../views/SignUp.vue'
import UserConfirmation from '../views/UserConfirmation.vue'
import Dashboard from '../views/Dashboard.vue'
import UserModule from '@/store/modules/user'

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
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: Dashboard,
    meta: { requireLogin: true }
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach(async (to, _from, next) => {
  await UserModule.syncCurrentUser()
  if (
    to.matched.some(record => record.meta.requireLogin) &&
    !UserModule.isLogIn
  ) {
    next({ path: '/log_in' })
  } else {
    next()
  }
})

export default router
