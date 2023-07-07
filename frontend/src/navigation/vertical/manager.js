import {
  mdiClipboardClockOutline,
  mdiAccountGroupOutline,
  mdiAccountTieOutline,
  mdiAccountCogOutline,
} from '@mdi/js'

export default [
  {
    subheader: 'vMenu.manager',
  },
  {
    title: 'vMenu.project',
    icon: mdiClipboardClockOutline,
    to: 'project-list',
    resource: 'Project',
    action: 'all',
  },
  {
    title: 'vMenu.team',
    icon: mdiAccountGroupOutline,
    to: 'team-list',
    resource: 'Team',
    action: 'all',
  },
  {
    title: 'vMenu.developer',
    icon: mdiAccountTieOutline,
    to: 'developer-search',
    resource: 'Developer',
    action: 'all',
  },
  {
    title: 'vMenu.setting',
    icon: mdiAccountCogOutline,
    to: 'password-setting',
    resource: 'password_setting',
    action: 'all',
  },
]
