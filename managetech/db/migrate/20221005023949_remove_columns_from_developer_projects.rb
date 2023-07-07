class RemoveColumnsFromDeveloperProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :developer_projects, :velocity
    remove_column :developer_projects, :total_expected_work_hours
    remove_column :developer_projects, :work_rate
    remove_column :developer_projects, :num_documents
    remove_column :developer_projects, :num_messages
    remove_column :developer_projects, :num_reactions
    remove_column :developer_projects, :num_comments
    remove_column :developer_projects, :num_mentions
    remove_column :developer_projects, :avg_lead_time
    remove_column :developer_projects, :num_new_ticket
    remove_column :developer_projects, :num_pull_requests
    remove_column :developer_projects, :num_prs_merged
    remove_column :developer_projects, :num_reviews
    remove_column :developer_projects, :review_hours
  end
end
