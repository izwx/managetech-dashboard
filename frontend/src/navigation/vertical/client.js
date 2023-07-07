import {
  mdiClipboardClockOutline,
  mdiAccountCogOutline
} from '@mdi/js'

export default [
  {
    subheader: 'vMenu.client',
  },
  {
    title: 'vMenu.project',
    icon: mdiClipboardClockOutline,
    to: 'project-list',
    resource: 'Project',
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
