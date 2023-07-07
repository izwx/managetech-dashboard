class PullRequestSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :sprint_id, :developer_id, :reviewer_id, :title, :num_comments, :contents, :create_datetime, :merge_datetime
end
