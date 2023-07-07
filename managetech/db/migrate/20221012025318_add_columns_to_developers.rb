class AddColumnsToDevelopers < ActiveRecord::Migration[7.0]
  def change
    remove_timestamps :developers
    add_column :developers, :avg_velocity, :float, comment: "平均ベロシティ"
    add_column :developers, :avg_work_rate, :float, comment: "平均稼働率"
    add_column :developers, :num_documents, :float, comment: "ドキュメント数"
    add_column :developers, :avg_lead_time, :float, comment: "平均リードタイム"
    add_column :developers, :avg_reviews, :float, comment: "レビュー数"
    add_column :developers, :avg_review_hours, :float, comment: "平均レビュー時間"
    add_timestamps :developers, default: Time.zone.now
  end
end
