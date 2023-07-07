class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :team_name, null: false, default: ""
      t.integer :num_members, comment: "メンバ数"
      t.float :avg_velocity, comment: "平均ベロシティ"
      t.float :avg_work_rate, comment: "平均稼働率"
      t.integer :num_documents, comment: "ドキュメント数"
    end
  end
end
