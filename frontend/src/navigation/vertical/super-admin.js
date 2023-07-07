import {
  mdiFinance,
  mdiTextBoxMultipleOutline,
  mdiAccountMultipleOutline,
  mdiCogOutline,
  mdiAccountCogOutline
} from '@mdi/js'

export default [
  {
    subheader: 'vMenu.managetechAdmin',
  },
  {
    title: 'vMenu.reportSetting',
    icon: mdiFinance,
    to: 'report-setting',
    resource: 'report_setting',
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
    title: 'vMenu.userSearch',
    icon: mdiAccountMultipleOutline,
    to: 'user-search',
    resource: 'user_search',
    action: 'all',
  },
  {
    title: 'vMenu.systemSetting',
    icon: mdiCogOutline,
    children: [
      {
        title: 'vMenu.toolMasterSetting',
        to: 'tool-master',
        resource: 'tool_master',
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
        title: 'vMenu.developerCareer',
        to: 'developer-career',
        resource: 'developer_career',
        action: 'all',
      },
      {
        title: 'vMenu.companyManagement',
        to: 'company-management',
        resource: 'company_management',
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
