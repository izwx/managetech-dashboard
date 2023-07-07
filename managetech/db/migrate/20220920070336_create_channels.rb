class CreateChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :channels do |t|
      t.references :project, comment: "プロジェクト"
      t.references :tool, comment: "ツール"
      t.string :name, comment: "チャネル表示名"
      t.string :chanel_name, comment: "ツール内でのチャネルの識別子"
      t.timestamps
    end
  end
end
