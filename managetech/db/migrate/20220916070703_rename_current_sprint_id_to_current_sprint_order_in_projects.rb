class RenameCurrentSprintIdToCurrentSprintOrderInProjects < ActiveRecord::Migration[7.0]
  def up
    rename_column :projects, :current_sprint_id, :current_sprint_order
  end

  def down
    rename_column :projects, :current_sprint_order, :current_sprint_id
  end
end
