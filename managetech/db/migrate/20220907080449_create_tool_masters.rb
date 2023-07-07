class CreateToolMasters < ActiveRecord::Migration[7.0]
  def change
    create_table :tool_masters do |t|
      t.string :tool_name, null: false
    end
  end
end
