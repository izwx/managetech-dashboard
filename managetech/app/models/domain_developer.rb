class DomainDeveloper < ApplicationRecord
  belongs_to :domain_master, foreign_key: :domain_id, optional: true
  belongs_to :developer
end
