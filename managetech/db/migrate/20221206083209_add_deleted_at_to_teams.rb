class AddDeletedAtToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :deleted_at, :datetime
    add_index :teams, :deleted_at
  end
end
