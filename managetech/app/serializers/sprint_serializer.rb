class SprintSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :end_date, :num_members, :num_ticket, :num_backlog, :velocity,
             :total_work_hour, :close_work_hour, :avg_work_rate, :num_new_ticket,
             :num_pull_request, :num_prs_merged, :num_messages,
             :sprint_members_count, :order
end
