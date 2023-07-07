class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.references :company, null: false, index: true
      t.string :project_name, null: false
      t.integer :project_phase, comment: "3:新規,2:改修,1:運用"
      t.integer :sprint_week, comment: "1スプリントは何週間か"
      t.integer :backlog_sprint_id, comment: "バックログを示すsprint_id"
      t.integer :total_num_members, comment: "チーム総人数"
      t.float :avg_velocity, comment: "平均ベロシティ"
      t.float :avg_work_rate, comment: "平均稼働率"
      t.integer :num_documents, comment: "ドキュメント数"
      t.integer :current_sprint_id, comment: "現在のスプリント名（指定なければスプリント番号）"
      t.float :avg_lead_time, comment: "平均リードタイム"
      t.float :remain_work_hour, comment: "平均リードタイム×残バックログ"
      t.date :dead_line, comment: "納期"
      t.date :expect_release_date, comment: "終了予想日(平均リードタイム×残バックログから予想"
      t.integer :num_backlog, comment: "残バックログ"
      t.integer :num_messages, comment: "メッセージ数"
      t.integer :num_reactions, comment: "メッセージに対するリアクション数"
      t.integer :num_comments, comment: "メッセージに対するコメント数"
      t.integer :num_mentions, comment: "メンションされた数"
    end
  end
end
