class Mention < ApplicationRecord
  belongs_to :message
  belongs_to :project
  belongs_to :sprint
end
