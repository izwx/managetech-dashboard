class AddTimestampsToTeams < ActiveRecord::Migration[7.0]
  def change
    add_timestamps :teams, default: Time.zone.now
  end
end
