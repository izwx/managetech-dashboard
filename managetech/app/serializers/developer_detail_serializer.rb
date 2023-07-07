class DeveloperDetailSerializer < DeveloperSerializer
  def attributes(*args)
    data = super
    data[:velocity_transitions] = object.velocity_transitions
    data[:avg_lead_time_transitions] = object.avg_lead_time_transitions
    data[:num_new_ticket_transitions] = object.num_new_ticket_transitions
    data[:num_pull_requests_transitions] = object.num_pull_requests_transitions
    data[:num_prs_merged_transitions] = object.num_prs_merged_transitions
    data[:num_messages_transitions] = object.num_messages_transitions
    data[:skill_careers] = object.skill_careers
    data[:domain_careers] = object.domain_careers
    data
  end

  has_many :developer_tool_maps
end
