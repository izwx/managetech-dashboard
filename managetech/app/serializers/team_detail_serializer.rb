class TeamDetailSerializer < TeamSerializer
  def attributes(*args)
    data = super
    data[:velocity_transitions] = object.velocity_transitions
    data[:avg_lead_time_transitions] = object.avg_lead_time_transitions
    data[:num_new_ticket_transitions] = object.num_new_ticket_transitions
    data[:num_pull_requests_transitions] = object.num_pull_requests_transitions
    data[:num_prs_merged_transitions] = object.num_prs_merged_transitions
    data[:num_messages_transitions] = object.num_messages_transitions
    data[:top_num_comments] = object.top_num_comments
    data[:top_num_pull_requests] = object.top_num_pull_requests
    data[:top_num_messages] = object.top_num_messages
    data[:top_avg_lead_time] = object.top_avg_lead_time
    data
  end

  has_many :projects
  has_many :developers
  has_one :current_projects
  has_many :developer_team_maps
end
