class AddSprintUidToSprints < ActiveRecord::Migration[7.0]
  def change
    add_column :sprints, :sprint_uid, :string
    add_index :sprints, :sprint_uid, unique: true
  end
end
