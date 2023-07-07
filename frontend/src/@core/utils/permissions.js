const allPermissions = {
  manager: [
    {
      action: 'all',
      subject: 'Project',
    },
    {
      action: 'all',
      subject: 'Team',
    },
    {
      action: 'all',
      subject: 'Developer',
    },
    {
      action: 'all',
      subject: 'password_setting',
    },
  ],
  client: [
    {
      action: 'all',
      subject: 'Project',
    },
    {
      action: 'all',
      subject: 'password_setting',
    },
  ],
  projectManager: [
    {
      action: 'all',
      subject: 'Project',
    },
    {
      action: 'all',
      subject: 'Sprint',
    },
    {
      action: 'all',
      subject: 'Team',
    },
    {
      action: 'all',
      subject: 'Log',
    },
    {
      action: 'all',
      subject: 'Developer',
    },
    {
      action: 'all',
      subject: 'developer_management',
    },
    {
      action: 'all',
      subject: 'project_management',
    },
    {
      action: 'all',
      subject: 'company_management',
    },
    {
      action: 'all',
      subject: 'skill_master',
    },
    {
      action: 'all',
      subject: 'domain_master',
    },
    {
      action: 'all',
      subject: 'tool_master',
    },
    {
      action: 'all',
      subject: 'developer_career',
    },
    {
      action: 'all',
      subject: 'password_setting',
    },
    {
      action: 'all',
      subject: 'profile_setting',
    },
    {
      action: 'read',
      subject: 'Public',
    },
  ],
  developer: [
    {
      action: 'all',
      subject: 'Project',
    },
    {
      action: 'all',
      subject: 'Sprint',
    },
    {
      action: 'all',
      subject: 'Team',
    },
    {
      action: 'all',
      subject: 'Developer',
    },
    {
      action: 'all',
      subject: 'password_setting',
    },
    {
      action: 'all',
      subject: 'profile_setting',
    },
    {
      action: 'all',
      subject: 'developer_career',
    },
  ],
  superAdmin: [
    {
      action: 'all',
      subject: 'report_setting',
    },
    {
      action: 'all',
      subject: 'Log',
    },
    {
      action: 'all',
      subject: 'user_search',
    },
    {
      action: 'all',
      subject: 'company_management',
    },
    {
      action: 'all',
      subject: 'system_setting',
    },
    {
      action: 'all',
      subject: 'tool_master',
    },
    {
      action: 'all',
      subject: 'skill_master',
    },
    {
      action: 'all',
      subject: 'domain_master',
    },
    {
      action: 'all',
      subject: 'developer_career',
    },
    {
      action: 'all',
      subject: 'password_setting',
    },
  ],
}

export const getPermission = role => {
  return allPermissions[role]
}
