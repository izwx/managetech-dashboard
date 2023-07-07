class AddDeletedAtToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :deleted_at, :datetime
    add_index :channels, :deleted_at
  end
end
