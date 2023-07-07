class SkillMaster < ApplicationRecord
  acts_as_paranoid

  belongs_to :project
  belongs_to :creater, class_name: "User", foreign_key: :creater_id, optional: true
  has_many :skill_developers
  has_many :developers, through: :skill_developers

  has_many :career_skills, class_name: "CareerSkill", foreign_key: "skill_id"
  has_many :developer_careers, through: :career_skills

  def self.search(search)
    wildcard_search = "%#{search}%"
    where("skill_name ILIKE ?", wildcard_search)
  end
end
