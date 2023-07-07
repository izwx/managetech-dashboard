class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :developer, comment: "発言者"
      t.references :project, comment: "プロジェクト"
      t.references :sprint, comment: "スプリント"
      t.references :reply_to, comment: "どのメッセージへのコメントか。親メッセージならnull"
      t.string :channel, comment: "チャネル名"
      t.string :url
      t.string :contents
      t.integer :num_reactions, comment: "リアクションの数"
      t.timestamps
    end
  end
end
