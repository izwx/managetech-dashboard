class SprintDetailSerializer < SprintSerializer
  def attributes(*args)
    data = super
    data[:prev_sprint] = prev_sprint
    data[:num_backlog_transitions] = object.num_backlog_transitions
    data[:velocity_transitions] = object.velocity_transitions
    data[:num_new_ticket_transitions] = object.num_new_ticket_transitions
    data[:num_pull_request_transitions] = object.num_pull_request_transitions
    data[:num_prs_merged_transitions] = object.num_prs_merged_transitions
    data[:num_messages_transitions] = object.num_messages_transitions
    data[:unclosed_tickets] = object.unclosed_tickets
    data
  end

  def prev_sprint
    {
      num_ticket: object.prev_sprint.num_ticket,
      total_work_hour: object.prev_sprint.total_work_hour,
      close_work_hour: object.prev_sprint.close_work_hour,
      velocity: object.prev_sprint.velocity,
      avg_work_rate: object.prev_sprint.avg_work_rate,
      num_new_ticket: object.prev_sprint.num_new_ticket,
      num_pull_request: object.prev_sprint.num_pull_request,
      num_prs_merged: object.prev_sprint.num_prs_merged,
      num_messages: object.prev_sprint.num_messages,
      sprint_members_count: object.prev_sprint.sprint_members_count,
    }
  end
end
