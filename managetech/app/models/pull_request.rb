class PullRequest < ApplicationRecord
  acts_as_paranoid

  belongs_to :developer
  belongs_to :project
  belongs_to :sprint

  has_many :pull_request_reviewers, foreign_key: :pr_id
  has_many :reviewers, through: :pull_request_reviewers, source: :developer
end
