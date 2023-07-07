class AddAvgLeadTimeToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :avg_lead_time, :float
  end
end
