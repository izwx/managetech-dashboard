class RemoveColumnsFromDeveloperProjectSprints < ActiveRecord::Migration[7.0]
  def change
    remove_column :developer_project_sprints, :velocity
    remove_column :developer_project_sprints, :total_expected_work_hours
    remove_column :developer_project_sprints, :work_rate
    remove_column :developer_project_sprints, :num_documents
    remove_column :developer_project_sprints, :num_messages
    remove_column :developer_project_sprints, :num_reactions
    remove_column :developer_project_sprints, :num_comments
    remove_column :developer_project_sprints, :num_mentions
    remove_column :developer_project_sprints, :avg_lead_time
    remove_column :developer_project_sprints, :num_new_ticket
    remove_column :developer_project_sprints, :num_pull_requests
    remove_column :developer_project_sprints, :num_prs_merged
    remove_column :developer_project_sprints, :num_reviews
    remove_column :developer_project_sprints, :review_hours
  end
end
