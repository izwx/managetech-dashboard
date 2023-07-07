class AddDeletedAtToMentions < ActiveRecord::Migration[7.0]
  def change
    add_column :mentions, :deleted_at, :datetime
    add_index :mentions, :deleted_at
  end
end
