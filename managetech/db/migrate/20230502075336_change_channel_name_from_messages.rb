class ChangeChannelNameFromMessages < ActiveRecord::Migration[7.0]
  def change
    rename_column :messages, :channel, :channel_uid
  end
end
