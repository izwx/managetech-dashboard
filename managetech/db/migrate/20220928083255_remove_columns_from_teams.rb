class RemoveColumnsFromTeams < ActiveRecord::Migration[7.0]
  def change
    remove_column :teams, :num_members
    remove_column :teams, :avg_velocity
    remove_column :teams, :avg_work_rate
    remove_column :teams, :avg_lead_time
    remove_column :teams, :num_documents
  end
end
