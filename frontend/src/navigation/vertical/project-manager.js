import {
  mdiClipboardClockOutline,
  mdiAccountGroupOutline,
  mdiTextBoxMultipleOutline,
  mdiAccountTieOutline,
  mdiCogOutline,
  mdiAccountCogOutline
} from '@mdi/js'

export default [
  {
    subheader: 'vMenu.projectManager',
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
    title: 'vMenu.logManagement',
    icon: mdiTextBoxMultipleOutline,
    to: 'log-management',
    resource: 'Log',
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
    title: 'vMenu.managetechSetting',
    icon: mdiCogOutline,
    children: [
      {
        title: 'vMenu.projectManagement',
        to: 'project-management',
        resource: 'Project',
        action: 'all',
      },
      {
        title: 'vMenu.teamManagement',
        to: 'team-management',
        resource: 'Team',
        action: 'all',
      },
      {
        title: 'vMenu.developerManagement',
        to: 'developer-management',
        resource: 'Developer',
        action: 'all',
      },
      {
        title: 'vMenu.companyManagement',
        to: 'company-management',
        resource: 'company_management',
        action: 'all',
      },
      {
        title: 'vMenu.skillSetting',
        to: 'skill-master',
        resource: 'skill_master',
        action: 'all',
      },
      {
        title: 'vMenu.domainSetting',
        to: 'domain-master',
        resource: 'domain_master',
        action: 'all',
      },
      {
        title: 'vMenu.toolMasterSetting',
        to: 'tool-project',
        resource: 'tool_master',
        action: 'all',
      },
      {
        title: 'vMenu.developerCareer',
        to: 'developer-career',
        resource: 'developer_career',
        action: 'all',
      },
    ],
  },
  {
    title: 'vMenu.setting',
    icon: mdiAccountCogOutline,
    to: 'password-setting',
    resource: 'password_setting',
    action: 'all',
  },
]
