class DeveloperProjectSprint < ApplicationRecord
  belongs_to :developer
  belongs_to :project
  belongs_to :sprint
end
