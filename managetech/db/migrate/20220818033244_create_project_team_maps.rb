class CreateProjectTeamMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :project_team_maps do |t|
      t.references :project, null: false
      t.references :team, null: false
      t.index([:project_id, :team_id], unique: true)
    end
  end
end
