class TeamSerializer < ActiveModel::Serializer
  attributes :id, :team_name, :company_id, :num_members, :avg_velocity, :avg_work_rate, :num_documents, :avg_lead_time
end
