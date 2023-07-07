class AddUidColumnToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :message_uid, :string
    add_index :messages, :message_uid, unique: true
  end
end
