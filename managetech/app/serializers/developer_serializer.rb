class DeveloperSerializer < ActiveModel::Serializer
  attributes :id, :developer_name, :avg_velocity, :avg_work_rate, :num_documents, :avg_lead_time, :avg_reviews, :avg_review_hours, :user_id

  has_many :teams
end
