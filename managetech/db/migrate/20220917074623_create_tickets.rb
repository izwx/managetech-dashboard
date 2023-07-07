class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.references :developer, null: false, comment: "担当者"
      t.references :project, null: false
      t.references :sprint, null: false
      t.string :title
      t.string :url
      t.string :status, comment: "ステータス"
      t.string :difficulty, comment: "難易度"
      t.datetime :start_date, comment: "開始日"
      t.integer :expect_hours, comment: "予想工数"
      t.integer :work_hours, comment: "作業工数"
      t.datetime :end_date, comment: "完了日"
      t.datetime :create_date, comment: "チケット作成日"
      t.timestamps
    end
  end
end
