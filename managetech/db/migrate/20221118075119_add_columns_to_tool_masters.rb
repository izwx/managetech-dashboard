class AddColumnsToToolMasters < ActiveRecord::Migration[7.0]
  def change
    add_column :tool_masters, :token_guide, :string
    add_column :tool_masters, :target_guide, :string
    add_column :tool_masters, :payload_guide, :string
    add_column :tool_masters, :account_name_guide, :string
  end
end
