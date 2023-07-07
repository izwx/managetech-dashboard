class Developer < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_many :developer_team_maps, inverse_of: :developer
  has_many :teams, through: :developer_team_maps
  accepts_nested_attributes_for :developer_team_maps, allow_destroy: true

  has_many :developer_projects, inverse_of: :developer
  has_many :projects, through: :developer_projects
  has_many :current_projects, -> { where(project_status: Project.project_statuses[:active]) }, through: :developer_projects, source: :project
  accepts_nested_attributes_for :developer_projects, allow_destroy: true

  has_many :developer_project_sprints
  has_many :sprints, through: :developer_project_sprints

  has_many :skill_developers
  has_many :skills, through: :skill_developers, source: :skill_master

  has_many :domain_developers
  has_many :domains, through: :domain_developers, source: :domain_master

  has_many :developer_tool_maps, inverse_of: :developer
  has_many :tools, through: :developer_tool_maps, source: :tool_master
  accepts_nested_attributes_for :developer_tool_maps, allow_destroy: true

  has_many :developer_careers
  has_many :tickets
  has_many :pull_requests
  has_many :messages
  has_many :documents

  has_many :pull_request_reviewers, foreign_key: :reviewer_id
  has_many :prs, through: :pull_request_reviewers, source: :pull_request

  self.per_page = 10

  def self.search(search)
    wildcard_search = "%#{search}%"
    joins(:user).where("users.name ILIKE ?", wildcard_search)
  end

  def developer_name
    self.user.name
  end

  def avg_lead_time_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.avg_lead_time)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def velocity_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.velocity)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_new_ticket_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.num_new_ticket)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_pull_requests_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.num_pull_requests)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_prs_merged_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.num_prs_merged)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_messages_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.num_messages)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def skill_careers
    skill_developers.joins(:skill_master).select(:id, :skill_id, :months, "skill_masters.skill_name as skill_name")
  end

  def domain_careers
    domain_developers.joins(:domain_master).select(:id, :domain_id, :months, "domain_masters.domain_name as domain_name")
  end
end
