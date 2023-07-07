class AddStartDateEndDateToDeveloperProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :developer_projects, :start_date, :datetime
    add_column :developer_projects, :end_date, :datetime
  end
end
