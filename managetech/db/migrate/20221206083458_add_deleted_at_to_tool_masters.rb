class AddDeletedAtToToolMasters < ActiveRecord::Migration[7.0]
  def change
    add_column :tool_masters, :deleted_at, :datetime
    add_index :tool_masters, :deleted_at
  end
end
