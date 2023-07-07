class CreateDevelopers < ActiveRecord::Migration[7.0]
  def change
    create_table :developers do |t|
      t.string :company_id
      t.string :deveolper_name, null: false, default: ""
      t.float :avg_velocity, comment: "平均ベロシティ"
      t.float :avg_work_rate, comment: "平均稼働率"
      t.float :num_documents, comment: "ドキュメント数"
      t.float :avg_lead_time, comment: "平均リードタイム"
      t.float :avg_reviews, comment: "レビュー数"
      t.float :avg_review_hours, comment: "平均レビュー時間"
    end
  end
end
