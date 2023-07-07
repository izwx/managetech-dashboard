class BatchLog < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  belongs_to :project

  def self.search(search)
    wildcard_search = "%#{search}%"
    joins(:company, :project).where("batch_type ILIKE :keyword or module ILIKE :keyword or companies.company_name ILIKE :keyword or projects.project_name ILIKE :keyword", keyword: wildcard_search)
  end
end
