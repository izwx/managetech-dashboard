class Company < ApplicationRecord
  acts_as_paranoid

  has_many :users
  has_many :teams
  has_many :projects
  has_many :client_projects, class_name: "Project", foreign_key: "client_company_id"
  has_many :batch_logs

  self.per_page = 10

  def self.search(search)
    wildcard_search = "%#{search}%"
    where("company_name ILIKE ?", wildcard_search)
  end
end
