class ChangeColumnsFromPullRequests < ActiveRecord::Migration[7.0]
  def change
    change_column_null :pull_requests, :project_id, true
    change_column_null :pull_requests, :sprint_id, true
    change_column_null :pull_requests, :developer_id, true
  end
end
