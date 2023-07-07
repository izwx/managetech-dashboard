class AddUidColumnToMentions < ActiveRecord::Migration[7.0]
  def change
    add_column :mentions, :mention_uid, :string
    add_index :mentions, :mention_uid, unique: true
  end
end
