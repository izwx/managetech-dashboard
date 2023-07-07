class CreatePullRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :pull_requests do |t|
      t.references :project, null: false
      t.references :sprint, null: false
      t.references :developer, null: false, comment: "担当者"
      t.references :reviewer, comment: "レビュアーのdeveloper_id"
      t.string :title, comment: "タイトル"
      t.integer :num_comments, comment: "コメント数"
      t.text :contents, comment: "内容"
      t.datetime :create_datetime, comment: "作成日時"
      t.datetime :merge_datetime, comment: "マージ日時（完了してなければnull）"

      t.timestamps
    end
  end
end
