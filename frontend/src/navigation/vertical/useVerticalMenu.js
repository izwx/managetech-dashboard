import store from '@/store'
import projectManager from './project-manager'
import superAdmin from './super-admin'
import manager from './manager'
import client from './client'
import developer from './developer'

export default function useVerticalMenu() {

  const userRole = store.state.sessionManager.user.role

  const menuItems = [
      ... userRole === 'projectManager' ? projectManager : [],
      ... userRole === 'superAdmin' ? superAdmin : [],
      ... userRole === 'manager' ? manager : [],
      ... userRole === 'client' ? client : [],
      ... userRole === 'developer' ? developer : [],
    ]

  return {
    menuItems
  }
}