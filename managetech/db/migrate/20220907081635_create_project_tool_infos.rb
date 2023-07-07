class CreateProjectToolInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :project_tool_infos do |t|
      t.references :project, null: false
      t.references :tool, null: false
      t.string :token, comment: "APIアクセス用のTokenやパスワードを想定"
      t.string :target, comment: "SlackのチャネルやJiraのプロジェクト、Gitのリポジトリ名などを想定"
      t.string :payload, comment: "その他のデータ"

      t.index([:project_id, :tool_id], unique: true)
    end
  end
end
