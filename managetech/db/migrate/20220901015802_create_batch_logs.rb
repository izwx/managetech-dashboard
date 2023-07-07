class CreateBatchLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :batch_logs do |t|
      t.references :company, null: false, index: true, comment: "会社ID"
      t.references :project, null: false, index: true, comment: "プロジェクトID"
      t.string :module, comment: "バッチ名"
      t.string :batch_type, comment: "error, warning, info"
      t.text :content, comment: "内容"
      t.datetime :start_datetime, comment: "開始日時"
      t.datetime :end_datetime, comment: "終了日時"
    end
  end
end
