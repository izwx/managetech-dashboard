class CareerSkill < ApplicationRecord
  belongs_to :career, class_name: "DeveloperCareer", foreign_key: "career_id"
  belongs_to :skill, class_name: "SkillMaster", foreign_key: "skill_id"
end
