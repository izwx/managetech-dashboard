class Team < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  has_many :developer_team_maps, inverse_of: :team
  has_many :developers, through: :developer_team_maps

  has_many :project_team_maps, class_name: "ProjectTeamMap", inverse_of: :team
  has_many :projects, through: :project_team_maps

  has_many :current_projects, -> { where(project_status: Project.project_statuses[:active]) }, through: :project_team_maps, source: :project

  self.per_page = 10

  def self.search(search)
    wildcard_search = "%#{search}%"
    where("team_name ILIKE ?", wildcard_search)
  end

  def velocity_transitions
    DeveloperProjectSprint.joins(:sprint).select(:sprint_id, "sprints.end_date", "SUM(developer_project_sprints.velocity)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .where(developer_id: self.developers)
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def avg_lead_time_transitions
    DeveloperProjectSprint.joins(:sprint).select(:sprint_id, "sprints.end_date", "SUM(developer_project_sprints.avg_lead_time)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .where(developer_id: self.developers)
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_new_ticket_transitions
    DeveloperProjectSprint.joins(:sprint).select(:sprint_id, "sprints.end_date", "SUM(developer_project_sprints.num_new_ticket)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .where(developer_id: self.developers)
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_pull_requests_transitions
    DeveloperProjectSprint.joins(:sprint).select(:sprint_id, "sprints.end_date", "SUM(developer_project_sprints.num_pull_requests)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .where(developer_id: self.developers)
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_prs_merged_transitions
    DeveloperProjectSprint.joins(:sprint).select(:sprint_id, "sprints.end_date", "SUM(developer_project_sprints.num_prs_merged)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .where(developer_id: self.developers)
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_messages_transitions
    DeveloperProjectSprint.joins(:sprint).select(:sprint_id, "sprints.end_date", "SUM(developer_project_sprints.num_messages)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .where(developer_id: self.developers)
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def top_num_comments
    DeveloperProjectSprint.joins(developer: [:user]).select(:developer_id, "users.name AS developer_name", "SUM(developer_project_sprints.num_comments)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .where(developer_id: self.developers)
      .order("sum DESC")
      .group([:"developer_project_sprints.developer_id", :"users.name"])
  end

  def top_num_pull_requests
    DeveloperProjectSprint.joins(developer: [:user]).select(:developer_id, "users.name AS developer_name", "SUM(developer_project_sprints.num_pull_requests)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .where(developer_id: self.developers)
      .order("sum DESC")
      .group([:"developer_project_sprints.developer_id", :"users.name"])
  end

  def top_num_messages
    DeveloperProjectSprint.joins(developer: [:user]).select(:developer_id, "users.name AS developer_name", "SUM(developer_project_sprints.num_messages)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .where(developer_id: self.developers)
      .order("sum DESC")
      .group([:"developer_project_sprints.developer_id", :"users.name"])
  end

  def top_avg_lead_time
    DeveloperProjectSprint.joins(developer: [:user]).select(:developer_id, "users.name AS developer_name", "SUM(developer_project_sprints.avg_lead_time)")
      .where(sprint_id: Sprint.where(project_id: self.current_projects))
      .where(developer_id: self.developers)
      .order("sum DESC")
      .group([:"developer_project_sprints.developer_id", :"users.name"])
  end
end
