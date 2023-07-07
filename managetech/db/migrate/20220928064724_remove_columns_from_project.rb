class RemoveColumnsFromProject < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :total_num_members
    remove_column :projects, :avg_velocity
    remove_column :projects, :avg_work_rate
    remove_column :projects, :num_documents
    remove_column :projects, :avg_lead_time
    remove_column :projects, :remain_work_hour
    remove_column :projects, :dead_line
    remove_column :projects, :expect_release_date
    remove_column :projects, :num_backlog
    remove_column :projects, :num_messages
    remove_column :projects, :num_reactions
    remove_column :projects, :num_comments
    remove_column :projects, :num_mentions
  end
end
