class CreateSprints < ActiveRecord::Migration[7.0]
  def change
    create_table :sprints do |t|
      t.string :name, comment: "スプリント名(Jira-Sprint-スプリント名)"
      t.references :project, null: false, comment: "スプリント名(Jira-Sprint-プロジェクト)"
      t.date :start_date, comment: "開始日(Jira-Sprint-開始日)"
      t.date :end_date, comment: "開始日(Jira-Sprint-開始日)"
      t.integer :num_members, comment: "チーム人数"
      t.integer :num_ticket, comment: "チケット数"
      t.float :total_work_hour, comment: "総工数"
      t.float :close_work_hour, comment: "完了工数"
      t.float :velocity, comment: "ベロシティ"
      t.float :avg_work_rate, comment: "平均稼働率"
      t.integer :num_new_ticket, comment: "新規チケット数"
      t.integer :num_pull_request, comment: "プルリク数"
      t.integer :num_prs_merged, comment: "マージ済PR数"
      t.integer :num_documents, comment: "ドキュメント数"
      t.integer :num_messages, comment: "メッセージ数"
      t.integer :num_reactions, comment: "メッセージに対するリアクション数"
      t.integer :num_comments, comment: "メッセージに対するコメント数"
      t.integer :num_mentions, comment: "メンションされた数"
      t.integer :status, comment: "スプリントが完了したかどうか（終了日を過ぎたか）"
    end
  end
end
