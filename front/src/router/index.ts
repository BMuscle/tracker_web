import Vue from 'vue'
import VueRouter, { Route, RouteConfig, NavigationGuardNext } from 'vue-router'
import Home from '../views/Home.vue'
import Login from '../views/LogIn.vue'
import SignUp from '../views/SignUp.vue'
import UserConfirmation from '../views/UserConfirmation.vue'
import Dashboard from '../views/Dashboard.vue'
import TeamDashBoard from '@/components/TeamDashboard.vue'
import TeamConfirmInvite from '@/components/TeamConfirmInvite.vue'
import UserModule from '@/store/modules/user'

Vue.use(VueRouter)

const redirectIfLoggedIn = async function (
  _to: Route,
  _from: Route,
  next: NavigationGuardNext<Vue>
) {
  await UserModule.syncCurrentUser()
  if (UserModule.isLogIn) {
    next({ path: '/dashboard' })
  } else {
    next()
  }
}

const routes: Array<RouteConfig> = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/log_in',
    name: 'LogIn',
    component: Login,
    beforeEnter: redirectIfLoggedIn
  },
  {
    path: '/sign_up',
    name: 'SignUp',
    component: SignUp,
    beforeEnter: redirectIfLoggedIn
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
    meta: { requireLogin: true },
    children: [
      {
        path: 'teams/:teamId',
        name: 'TeamDashBoard',
        component: TeamDashBoard
      }
    ]
  },
  {
    path: '/teams/invites/confirm',
    name: 'TeamConfirmInvite',
    component: TeamConfirmInvite,
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
    next({ path: '/log_in', query: { redirect: to.fullPath } })
  } else {
    next()
  }
})

export default router
