class AddUidColumnToPullRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :pull_requests, :pull_request_uid, :string
    add_index :pull_requests, :pull_request_uid, unique: true
  end
end
