import {
  mdiClipboardClockOutline,
  mdiAccountGroupOutline,
  mdiAccountTieOutline,
  mdiAccountCogOutline,
  mdiAccountClockOutline,
} from '@mdi/js'

export default [
  {
    subheader: 'vMenu.developer',
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
    title: 'vMenu.developerCareer',
    icon: mdiAccountClockOutline,
    to: 'developer-career',
    resource: 'developer_career',
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