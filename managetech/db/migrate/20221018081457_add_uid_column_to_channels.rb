class AddUidColumnToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :channel_uid, :string
    add_index :channels, :channel_uid, unique: true
  end
end
