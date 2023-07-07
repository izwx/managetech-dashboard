import { canNavigate } from '@/plugins/acl/routeProtection'
import Vue from 'vue'
import VueRouter from 'vue-router'
import apps from './apps'
import dashboard from './dashboard'
import pages from './pages'
import userInterface from './user-interface'

Vue.use(VueRouter)

const routes = [
  // ? We are redirecting to different pages based on role.
  // NOTE: Role is just for UI purposes. ACL is based on abilities.
  {
    path: '/',
    redirect: to => {
      const userData = JSON.parse(localStorage.getItem('userData'))
      const userRole = userData && userData.role ? userData.role : null

      if (userRole === 'manager') return { name: 'project-list' }
      if (userRole === 'client') return { name: 'project-list' }
      if (userRole === 'projectManager') return { name: 'project-list' }
      if (userRole === 'developer') return { name: 'project-list' }
      if (userRole === 'superAdmin') return { name: 'report-setting' }

      // return { name: 'auth-login', query: to.query }
    },
  },
  {
    path: '/team_list',
    name: 'team-list',
    component: () => import('@/views/team/team-list/TeamList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'Team'
    }
  },
  {
    path: '/team/view/:id',
    name: 'team-view',
    component: () => import('@/views/team/team-view/TeamView.vue'),
    meta: {
      layout: 'content',
      action: 'all',
      resource: 'Team'
    },
  },
  {
    path: '/developer_search',
    name: 'developer-search',
    component: () => import('@/views/developer/developer-list/DeveloperList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'Developer'
    }
  },
  {
    path: '/developer/view/:id',
    name: 'developer-view',
    component: () => import('@/views/developer/developer-view/DeveloperView.vue'),
    meta: {
      layout: 'content',
      action: 'all',
      resource: 'Developer'
    },
  },
  {
    path: '/project_list',
    name: 'project-list',
    component: () => import('@/views/project/project-list/ProjectList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'Project'
    }
  },
  {
    path: '/project/view/:id',
    name: 'project-view',
    component: () => import('@/views/project/project-view/ProjectView.vue'),
    meta: {
      layout: 'content',
      action: 'all',
      resource: 'Project'
    },
  },
  {
    path: '/report_setting',
    name: 'report-setting',
    component: () => import('@/views/report/Report.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'report_setting'
    }
  },
  {
    path: '/log_management',
    name: 'log-management',
    component: () => import('@/views/log/LogList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'Log'
    }
  },
  {
    path: '/user_search',
    name: 'user-search',
    component: () => import('@/views/user/UserList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'user_search'
    }
  },
  {
    path: '/project_management',
    name: 'project-management',
    component: () => import('@/views/project/project-list/ProjectList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'Project'
    }
  },
  {
    path: '/sprint/view/:id',
    name: 'sprint-view',
    component: () => import('@/views/sprint/SprintView.vue'),
    meta: {
      layout: 'content',
      action: 'all',
      resource: 'Sprint'
    },
  },
  {
    path: '/team_management',
    name: 'team-management',
    component: () => import('@/views/team/team-list/TeamList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'Team'
    }
  },
  {
    path: '/developer_management',
    name: 'developer-management',
    component: () => import('@/views/developer/developer-list/DeveloperList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'Developer'
    }
  },
  {
    path: '/company_management',
    name: 'company-management',
    component: () => import('@/views/company/company-list/CompanyList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'company_management'
    }
  },
  {
    path: '/system_setting',
    name: 'system-setting',
    component: () => import('@/views/dashboards/analytics/Analytics.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'system_setting'
    }
  },
  {
    path: '/tool_master',
    name: 'tool-master',
    component: () => import('@/views/tool/tool-list/ToolList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'tool_master'
    }
  },
  {
    path: '/tool_project',
    name: 'tool-project',
    component: () => import('@/views/tool/tool-project/ToolProjectList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'tool_master'
    }
  },
  {
    path: '/tool_project/project/:id',
    name: 'tool-project-view',
    component: () => import('@/views/tool/tool-project/ToolProjectView.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'tool_master'
    }
  },
  {
    path: '/skill_master',
    name: 'skill-master',
    component: () => import('@/views/skill/SkillList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'skill_master'
    }
  },
  {
    path: '/domain_master',
    name: 'domain-master',
    component: () => import('@/views/domain/DomainList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'domain_master'
    }
  },
  {
    path: '/developer_career',
    name: 'developer-career',
    component: () => import('@/views/career/CareerList.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'developer_career'
    }
  },  
  {
    path: '/profile_setting',
    name: 'profile-setting',
    component: () => import('@/views/profile/Profile.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'profile_setting'
    }
  },
  {
    path: '/password_setting',
    name: 'password-setting',
    component: () => import('@/views/profile/Profile.vue'),
    meta :{
      layout: 'content',
      action: 'all',
      resource: 'password_setting'
    }
  },
  {
    path: '/error-404',
    name: 'error-404',
    component: () => import('@/views/Error404.vue'),
    meta: {
      layout: 'blank',
      resource: 'Public',
    },
  },
  {
    path: '/login',
    name: 'auth-login',
    component: () => import('@/views/Login.vue'),
    meta: {
      layout: 'blank',
      resource: 'Public',
      redirectIfLoggedIn: true,
    },
  },
  {
    path: '/register',
    name: 'auth-register',
    component: () => import('@/views/Register.vue'),
    meta: {
      layout: 'blank',
      resource: 'Public',
      redirectIfLoggedIn: true,
    },
  },
  {
    path: '/forgot-password',
    name: 'auth-forgot-password',
    component: () => import('@/views/ForgotPassword.vue'),
    meta: {
      layout: 'blank',
      resource: 'Public',
      redirectIfLoggedIn: true,
    },
  },
  ...dashboard,
  ...userInterface,
  ...apps,
  ...pages,
  {
    path: '*',
    redirect: 'error-404',
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes,
  scrollBehavior() {
    return { x: 0, y: 0 }
  },
})

// ? Router Before Each hook: https://router.vuejs.org/guide/advanced/navigation-guards.html
router.beforeEach((to, _, next) => {

  const userData = localStorage.getItem('userData')

  let userDataExists = JSON.parse(userData) !== "undefined" && JSON.parse(userData) !== null;
  if (!userDataExists) {
    console.log("Removing accessToken because userData is empty")
    localStorage.removeItem('accessToken')
    localStorage.removeItem('userData')
    localStorage.removeItem('userAbility')
  }

  const isLoggedIn = userData && localStorage.getItem('accessToken') && localStorage.getItem('userAbility')

  // Redirect to login page if not logged in
  if(to.name != 'auth-login' && !isLoggedIn) {
    return next({ name: 'auth-login'})
  }

  if (!canNavigate(to)) {
    // Redirect to login if not logged in
    if (!isLoggedIn) return next({ name: 'auth-login' })

    // If logged in => not authorized
    return next({ name: 'misc-not-authorized' })
  }

  // Redirect if logged in
  if (to.meta.redirectIfLoggedIn && isLoggedIn) {
    next('/')
  }

  return next()
})

export default router
