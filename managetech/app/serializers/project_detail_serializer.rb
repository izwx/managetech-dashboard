class ProjectDetailSerializer < ProjectSerializer
  def attributes(*args)
    data = super
    data[:avg_lead_time_transitions] = object.avg_lead_time_transitions
    data[:num_backlog_transitions] = object.num_backlog_transitions
    data[:velocity_transitions] = object.velocity_transitions
    data[:num_new_ticket_transitions] = object.num_new_ticket_transitions
    data[:num_pull_requests_transitions] = object.num_pull_requests_transitions
    data[:num_prs_merged_transitions] = object.num_prs_merged_transitions
    data[:num_messages_transitions] = object.num_messages_transitions
    data[:low_work_rates] = object.low_work_rates
    data[:top_num_comments] = object.top_num_comments
    data[:top_pull_requests] = object.top_pull_requests
    data[:long_opened_tickets] = object.long_opened_tickets
    data[:long_unclosed_tickets] = object.long_unclosed_tickets
    data[:long_reviewed_prs] = object.long_reviewed_prs
    data
  end

  has_many :teams
  has_many :sprints
  has_many :project_tool_infos
  has_many :project_team_maps
end
