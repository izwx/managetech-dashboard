class CareerDomain < ApplicationRecord
  belongs_to :career, class_name: "DeveloperCareer", foreign_key: "career_id"
  belongs_to :domain, class_name: "DomainMaster", foreign_key: "domain_id"
end
