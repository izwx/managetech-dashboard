class AddColumnsToTeams < ActiveRecord::Migration[7.0]
  def change
    remove_timestamps :teams
    add_column :teams, :num_members, :integer, comment: "メンバ数"
    add_column :teams, :avg_velocity, :float, comment: "平均ベロシティ"
    add_column :teams, :avg_work_rate, :float, comment: "平均稼働率"
    add_column :teams, :avg_lead_time, :float, comment: "平均リードタイム"
    add_column :teams, :num_documents, :integer, comment: "ドキュメント数"
    add_timestamps :teams, default: Time.zone.now
  end
end
