class SkillDeveloper < ApplicationRecord
  belongs_to :skill_master, foreign_key: :skill_id, optional: true
  belongs_to :developer
end
