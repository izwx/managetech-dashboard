class DeveloperProject < ApplicationRecord
  belongs_to :developer
  belongs_to :project

  validates_presence_of :developer
  validates_presence_of :project

  accepts_nested_attributes_for :project
end
