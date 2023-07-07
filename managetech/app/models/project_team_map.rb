class ProjectTeamMap < ApplicationRecord
  belongs_to :project, class_name: "Project"
  belongs_to :team, class_name: "Team"

  validates_presence_of :project
  validates_presence_of :team

  accepts_nested_attributes_for :team

  validates_uniqueness_of :project_id, :scope => [:team_id]
  validates_uniqueness_of :team_id, :scope => [:project_id]
end
