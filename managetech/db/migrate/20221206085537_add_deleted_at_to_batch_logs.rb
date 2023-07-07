class AddDeletedAtToBatchLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :batch_logs, :deleted_at, :datetime
    add_index :batch_logs, :deleted_at
  end
end
