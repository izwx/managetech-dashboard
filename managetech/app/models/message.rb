class Message < ApplicationRecord
  acts_as_paranoid

  belongs_to :developer
  belongs_to :project
  belongs_to :sprint
  belongs_to :reply_to, class_name: "Message"
  has_many :mentions
end
