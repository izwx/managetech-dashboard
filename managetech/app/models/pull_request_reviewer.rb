class PullRequestReviewer < ApplicationRecord
  belongs_to :pull_request, foreign_key: :pr_id
  belongs_to :developer, foreign_key: :reviewer_id
end
