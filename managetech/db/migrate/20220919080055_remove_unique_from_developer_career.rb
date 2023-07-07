class RemoveUniqueFromDeveloperCareer < ActiveRecord::Migration[7.0]
  def change
    remove_index :developer_careers, [:developer_id, :project_id]
    add_index :developer_careers, [:developer_id, :project_id]
  end
end
