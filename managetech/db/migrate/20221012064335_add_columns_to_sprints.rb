class AddColumnsToSprints < ActiveRecord::Migration[7.0]
  def change
    add_column :sprints, :num_members, :integer, comment: "チーム人数"
    add_column :sprints, :num_ticket, :integer, comment: "チケット数"
    add_column :sprints, :num_backlog, :integer, comment: "バックログ数"
    add_column :sprints, :total_work_hour, :float, comment: "総工数"
    add_column :sprints, :close_work_hour, :float, comment: "完了工数"
    add_column :sprints, :velocity, :float, comment: "ベロシティ"
    add_column :sprints, :avg_work_rate, :float, comment: "平均稼働率"
    add_column :sprints, :num_new_ticket, :integer, comment: "新規チケット数"
    add_column :sprints, :num_pull_request, :integer, comment: "プルリク数"
    add_column :sprints, :num_prs_merged, :integer, comment: "マージ済PR数"
    add_column :sprints, :num_documents, :integer, comment: "ドキュメント数"
    add_column :sprints, :num_messages, :integer, comment: "メッセージ数"
    add_column :sprints, :num_reactions, :integer, comment: "メッセージに対するリアクション数"
    add_column :sprints, :num_comments, :integer, comment: "メッセージに対するコメント数"
    add_column :sprints, :num_mentions, :integer, comment: "メンションされた数"

    add_timestamps :sprints, default: Time.zone.now
  end
end
