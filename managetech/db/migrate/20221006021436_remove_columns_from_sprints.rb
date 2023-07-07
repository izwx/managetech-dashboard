class RemoveColumnsFromSprints < ActiveRecord::Migration[7.0]
  def change
    remove_column :sprints, :num_members
    remove_column :sprints, :num_ticket
    remove_column :sprints, :num_backlog
    remove_column :sprints, :total_work_hour
    remove_column :sprints, :close_work_hour
    remove_column :sprints, :velocity
    remove_column :sprints, :avg_work_rate
    remove_column :sprints, :num_new_ticket
    remove_column :sprints, :num_pull_request
    remove_column :sprints, :num_prs_merged
    remove_column :sprints, :num_documents
    remove_column :sprints, :num_messages
    remove_column :sprints, :num_reactions
    remove_column :sprints, :num_comments
    remove_column :sprints, :num_mentions
  end
end
