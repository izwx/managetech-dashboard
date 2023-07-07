class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :company_id, :client_company_id, :project_name, :project_status, :project_phase, :project_status, :sprint_week,
             :backlog_sprint_id, :total_num_members, :avg_velocity, :avg_work_rate,
             :num_documents, :current_sprint_order, :current_sprint, :avg_lead_time, :remain_work_hour,
             :expect_release_date, :num_backlog, :num_messages, :num_reactions, :num_comments, :progress_rate

  belongs_to :company
  belongs_to :client_company
end
