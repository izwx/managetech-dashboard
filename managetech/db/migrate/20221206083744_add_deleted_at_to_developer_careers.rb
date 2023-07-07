class AddDeletedAtToDeveloperCareers < ActiveRecord::Migration[7.0]
  def change
    add_column :developer_careers, :deleted_at, :datetime
    add_index :developer_careers, :deleted_at
  end
end
