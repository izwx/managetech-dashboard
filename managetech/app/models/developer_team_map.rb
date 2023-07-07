class DeveloperTeamMap < ApplicationRecord
  belongs_to :team
  belongs_to :developer

  validates_presence_of :team
  validates_presence_of :developer

  accepts_nested_attributes_for :team

  validates_uniqueness_of :team_id, :scope => [:developer_id]
  validates_uniqueness_of :developer_id, :scope => [:team_id]
end
