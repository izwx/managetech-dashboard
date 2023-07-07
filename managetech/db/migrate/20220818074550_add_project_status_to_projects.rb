class AddProjectStatusToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :project_status, :integer, default: Project.project_statuses[:inactive], comment: "0:Inactive,1:Active"
  end
end
