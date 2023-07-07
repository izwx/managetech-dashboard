class CreateDeveloperTeamMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :developer_team_maps do |t|
      t.references :developer, null: false
      t.references :team, null: false
      t.float :work_hour
      t.index([:developer_id, :team_id], unique: true)
    end
  end
end
