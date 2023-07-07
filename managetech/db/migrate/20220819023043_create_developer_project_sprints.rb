class CreateDeveloperProjectSprints < ActiveRecord::Migration[7.0]
  def change
    create_table :developer_project_sprints do |t|
      t.references :developer, null: false
      t.references :project, null: false
      t.references :sprint, null: false
      t.float :velocity, comment: "スプリントで完了させたチケットの数*チケットの難易度"
      t.float :total_expected_work_hours, comment: "予想工数の合計"
      t.float :work_rate, comment: "稼働率（完了したチケットの総工数/開発者の稼働時間の合計）"
      t.integer :num_documents, comment: "ドキュメント数"
      t.integer :num_messages, comment: "メッセージ数"
      t.integer :num_reactions, comment: "メッセージに対するリアクション数"
      t.integer :num_comments, comment: "メッセージに対するコメント数"
      t.integer :num_mentions, comment: "メンションされた数"
      t.float :avg_lead_time, comment: "完了したチケットの平均リードタイム（時間）"
      t.integer :num_new_ticket, comment: "新規チケット数"
      t.integer :num_pull_requests, comment: "プルリクエスト数"
      t.integer :num_prs_merged, comment: "マージされたプルリクエスト数"
      t.integer :num_reviews, comment: "レビュー数"
      t.float :review_hours, comment: "レビュー時間"

      t.index([:developer_id, :project_id, :sprint_id], unique: true, name: "index_developer_project_sprints")
    end
  end
end
