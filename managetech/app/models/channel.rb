class Channel < ApplicationRecord
  acts_as_paranoid

  belongs_to :project
  belongs_to :tool, class_name: "ToolMaster", foreign_key: :tool_id
end
