class CreatePullRequestReviewers < ActiveRecord::Migration[7.0]
  def change
    create_table :pull_request_reviewers do |t|
      t.references :pr
      t.references :reviewer

      t.index([:pr_id, :reviewer_id], unique: true)
    end
  end
end
