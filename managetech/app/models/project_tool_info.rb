class ProjectToolInfo < ApplicationRecord
  belongs_to :tool_master, foreign_key: :tool_id, optional: true
  belongs_to :project
end
