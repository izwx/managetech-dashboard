class Sprint < ApplicationRecord
  acts_as_paranoid

  belongs_to :project
  has_many :developer_project_sprints
  has_many :tickets
  has_many :pull_requests
  has_many :messages
  has_many :mentions
  has_many :documents

  def prev_sprint
    records = Sprint.order(end_date: :asc)
    records = records.where("end_date < ?", self.end_date) if self.end_date
    records.last
  end

  def sprint_members_count
    developer_project_sprints.count()
  end

  def num_backlog_transitions
    Sprint.select(:id, "num_backlog as avg", "end_date").where(project_id: self.project_id).order("sprints.end_date ASC").last(10)
  end

  def velocity_transitions
    Sprint.select(:id, "velocity as avg", "end_date").where(project_id: self.project_id).order("sprints.end_date ASC").last(10)
  end

  def num_new_ticket_transitions
    Sprint.select(:id, "num_new_ticket as avg", "end_date").where(project_id: self.project_id).order("sprints.end_date ASC").last(10)
  end

  def num_pull_request_transitions
    Sprint.select(:id, "num_pull_request as avg", "end_date").where(project_id: self.project_id).order("sprints.end_date ASC").last(10)
  end

  def num_prs_merged_transitions
    Sprint.select(:id, "num_prs_merged as avg", "end_date").where(project_id: self.project_id).order("sprints.end_date ASC").last(10)
  end

  def num_messages_transitions
    Sprint.select(:id, "num_messages as avg", "end_date").where(project_id: self.project_id).order("sprints.end_date ASC").last(10)
  end

  def unclosed_tickets
    Ticket.select(:id, :title, :end_date).where(project_id: self.project.id).where.not(status: "close")
  end
end
