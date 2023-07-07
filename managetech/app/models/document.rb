class Document < ApplicationRecord
  acts_as_paranoid

  belongs_to :project
  belongs_to :sprint
  belongs_to :developer
end
