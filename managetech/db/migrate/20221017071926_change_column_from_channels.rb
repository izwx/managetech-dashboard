class ChangeColumnFromChannels < ActiveRecord::Migration[7.0]
  def change
    rename_column :channels, :chanel_name, :channel_name
  end
end
