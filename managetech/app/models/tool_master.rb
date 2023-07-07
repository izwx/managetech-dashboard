class ToolMaster < ApplicationRecord
  acts_as_paranoid

  has_many :developer_tool_maps
  has_many :developers, through: :developer_tool_maps

  has_many :project_tool_infos
  has_many :projects, through: :project_tool_infos

  has_many :channels, class_name: "Channel", foreign_key: :tool_id

  def self.search(search)
    wildcard_search = "%#{search}%"
    where("tool_name ILIKE ?", wildcard_search)
  end
end
