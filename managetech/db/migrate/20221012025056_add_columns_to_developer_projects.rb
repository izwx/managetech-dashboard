class AddColumnsToDeveloperProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :developer_projects, :velocity, :float, comment: "スプリントで完了させたチケットの数*チケットの難易度"
    add_column :developer_projects, :total_expected_work_hours, :float, comment: "予想工数の合計"
    add_column :developer_projects, :work_rate, :float, comment: "稼働率（完了したチケットの総工数/開発者の稼働時間の合計）"
    add_column :developer_projects, :num_documents, :integer, comment: "ドキュメント数"
    add_column :developer_projects, :num_messages, :integer, comment: "メッセージ数"
    add_column :developer_projects, :num_reactions, :integer, comment: "メッセージに対するリアクション数"
    add_column :developer_projects, :num_comments, :integer, comment: "メッセージに対するコメント数"
    add_column :developer_projects, :num_mentions, :integer, comment: "メンションされた数"
    add_column :developer_projects, :avg_lead_time, :float, comment: "完了したチケットの平均リードタイム（時間）"
    add_column :developer_projects, :num_new_ticket, :integer, comment: "新規チケット数"
    add_column :developer_projects, :num_pull_requests, :integer, comment: "プルリクエスト数"
    add_column :developer_projects, :num_prs_merged, :integer, comment: "マージされたプルリクエスト数"
    add_column :developer_projects, :num_reviews, :integer, comment: "レビュー数"
    add_column :developer_projects, :review_hours, :float, comment: "レビュー時間"
  end
end
