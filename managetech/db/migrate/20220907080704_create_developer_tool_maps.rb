class CreateDeveloperToolMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :developer_tool_maps do |t|
      t.references :developer, null: false
      t.references :tool, null: false
      t.string :account_name, comment: "そのツールでの開発者のアカウント"

      t.index([:developer_id, :tool_id], unique: true)
    end
  end
end
