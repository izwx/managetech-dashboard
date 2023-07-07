class DeveloperCareer < ApplicationRecord
  acts_as_paranoid

  belongs_to :developer
  belongs_to :project

  has_many :career_skills, class_name: "CareerSkill", foreign_key: "career_id"
  has_many :skills, through: :career_skills

  has_many :career_domains, class_name: "CareerDomain", foreign_key: "career_id"
  has_many :domains, through: :career_domains

  enum role: {
    coder: 1,
    manager: 2,
    tl: 3,
  }, _prefix: true, _default: :coder

  def self.search(search)
    wildcard_search = "%#{search}%"
    joins(developer: [:user]).where("users.name ILIKE ?", wildcard_search)
  end
end
