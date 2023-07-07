class DomainMaster < ApplicationRecord
  acts_as_paranoid

  belongs_to :project
  belongs_to :creater, class_name: "User", foreign_key: :creater_id, optional: true

  has_many :domain_developers
  has_many :developers, through: :domain_developers

  has_many :career_domains, class_name: "CareerDomain", foreign_key: "domain_id"
  has_many :developer_careers, through: :career_domains, inverse_of: :domain_master

  def self.search(search)
    wildcard_search = "%#{search}%"
    where("domain_name ILIKE ?", wildcard_search)
  end
end
