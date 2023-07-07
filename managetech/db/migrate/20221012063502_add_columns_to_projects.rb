class AddColumnsToProjects < ActiveRecord::Migration[7.0]
  def change
    remove_timestamps :projects
    add_column :projects, :total_num_members, :integer, comment: "メンバ数"
    add_column :projects, :avg_velocity, :float, comment: "平均ベロシティ"
    add_column :projects, :avg_work_rate, :float, comment: "平均稼働率"
    add_column :projects, :num_documents, :integer, comment: "ドキュメント数"
    add_column :projects, :avg_lead_time, :float, comment: "平均リードタイム"
    add_column :projects, :remain_work_hour, :float, comment: "平均リードタイム×残バックログ"
    add_column :projects, :expect_release_date, :date, comment: "終了予想日(平均リードタイム×残バックログから予想"
    add_column :projects, :num_backlog, :integer, comment: "残バックログ"
    add_column :projects, :num_messages, :integer, comment: "メッセージ数"
    add_column :projects, :num_reactions, :integer, comment: "メッセージに対するリアクション数"
    add_column :projects, :num_comments, :integer, comment: "メッセージに対するコメント数"
    add_column :projects, :num_mentions, :integer, comment: "メンションされた数"
    add_timestamps :projects, default: Time.zone.now
  end
end
