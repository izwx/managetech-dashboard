class Project < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  belongs_to :client_company, class_name: "Company"

  has_many :project_team_maps, class_name: "ProjectTeamMap", inverse_of: :project
  has_many :teams, through: :project_team_maps

  has_many :developer_projects, inverse_of: :project
  has_many :developers, through: :developer_projects

  has_many :sprints
  has_many :developer_project_sprints
  has_many :skill_masters
  has_many :batch_logs
  has_many :developer_careers
  has_many :tickets
  has_many :pull_requests
  has_many :messages
  has_many :channels
  has_many :mentions
  has_many :documents

  has_many :project_tool_infos
  has_many :tools, through: :project_tool_infos, source: :tool_master

  enum project_phase: {
    maintenance: 1,
    update: 2,
    new: 3,
  }, _prefix: true, _default: :maintenance

  enum project_status: {
    inactive: 0,
    active: 1,
  }, _prefix: true, _default: :inactive

  def self.search(search)
    wildcard_search = "%#{search}%"
    where("project_name ILIKE ?", wildcard_search)
  end

  def current_sprint
    sprints.where(order: self.current_sprint_order).first
  end

  def avg_lead_time_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.avg_lead_time)")
      .where(sprint_id: Sprint.where(project_id: self.id))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_backlog_transitions
    sprints.select("id as sprint_id", :end_date, "num_backlog as avg")
      .where(project_id: self.id)
      .order("end_date ASC").last(10)
  end

  def velocity_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.velocity)")
      .where(sprint_id: Sprint.where(project_id: self.id))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_new_ticket_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.num_new_ticket)")
      .where(sprint_id: Sprint.where(project_id: self.id))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_pull_requests_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.num_pull_requests)")
      .where(sprint_id: Sprint.where(project_id: self.id))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_prs_merged_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.num_prs_merged)")
      .where(sprint_id: Sprint.where(project_id: self.id))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def num_messages_transitions
    developer_project_sprints.joins(:sprint).select(:sprint_id, "sprints.end_date", "AVG(developer_project_sprints.num_messages)")
      .where(sprint_id: Sprint.where(project_id: self.id))
      .order("sprints.end_date ASC")
      .group([:"developer_project_sprints.sprint_id", :"sprints.end_date"]).last(10)
  end

  def low_work_rates
    developer_projects.joins(developer: [:user]).select(:developer_id, "users.name AS developer_name", "developer_projects.work_rate as rate")
      .order("rate ASC")
      .last(5)
  end

  def top_num_comments
    developer_projects.joins(developer: [:user]).select(:developer_id, "users.name AS developer_name", "developer_projects.num_comments as rate")
      .order("rate DESC")
      .last(5)
  end

  def top_pull_requests
    pull_requests.select(:id, :title, "num_comments as rate")
      .order("rate DESC")
      .last(5)
  end

  def long_opened_tickets
    tickets.select(:id, :title, :start_date)
      .where("start_date < ?", Time.now - 10.days)
      .where.not(status: "close")
      .order("start_date ASC")
  end

  def long_unclosed_tickets
    tickets.select(:id, :title, :end_date)
      .where("end_date < ?", Time.now - 5.days)
      .where.not(status: "close")
      .order("end_date ASC")
  end

  def long_reviewed_prs
    pull_requests.select(:id, :title, :create_datetime)
      .where("create_datetime < ?", Time.now - 3.days)
  end

  def progress_rate
    total_tickets_count = Ticket.where(sprint_id: self.current_sprint.id).count
    if total_tickets_count != 0 || total_tickets_count != nil
      return self.num_backlog.fdiv(total_tickets_count) * 100
    else
      return 0
    end
  rescue
    return 0
  end
end
