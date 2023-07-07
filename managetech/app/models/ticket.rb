class Ticket < ApplicationRecord
  acts_as_paranoid

  belongs_to :developer
  belongs_to :project
  belongs_to :sprint

  def lead_time
    (Time.parse(self.end_date) - Time.parse(self.start_date)).seconds.in_hours.to_i
  end
end
