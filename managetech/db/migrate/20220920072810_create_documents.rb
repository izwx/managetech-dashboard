class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.references :project, comment: "プロジェクト"
      t.references :sprint, comment: "スプリント"
      t.references :developer, comment: "著者"
      t.string :title, comment: "タイトル"
      t.text :contents, comment: "内容"
      t.timestamps
    end
  end
end
