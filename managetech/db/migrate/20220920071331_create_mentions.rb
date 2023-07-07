class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :message, comment: "メッセージ"
      t.references :project, comment: "プロジェクト"
      t.references :sprint, comment: "スプリント"
      t.integer :mention_to, comment: "メンション先がdeveloper_idを持っていればレコードを作成"
      t.timestamps
    end
  end
end
