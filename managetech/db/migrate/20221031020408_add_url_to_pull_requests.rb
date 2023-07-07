class AddUrlToPullRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :pull_requests, :url, :string, comment: "元々のプルリクエストを表示するためのURL"
  end
end
