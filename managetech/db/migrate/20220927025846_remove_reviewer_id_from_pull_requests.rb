class RemoveReviewerIdFromPullRequests < ActiveRecord::Migration[7.0]
  def change
    remove_column :pull_requests, :reviewer_id
  end
end
