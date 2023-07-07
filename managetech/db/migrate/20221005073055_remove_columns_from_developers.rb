class RemoveColumnsFromDevelopers < ActiveRecord::Migration[7.0]
  def change
    remove_column :developers, :avg_velocity
    remove_column :developers, :avg_work_rate
    remove_column :developers, :num_documents
    remove_column :developers, :avg_lead_time
    remove_column :developers, :avg_reviews
    remove_column :developers, :avg_review_hours
  end
end
