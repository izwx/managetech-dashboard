class AddNameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    remove_column :users, :developer_id, :integer
  end
end
