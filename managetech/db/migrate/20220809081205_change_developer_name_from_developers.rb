class ChangeDeveloperNameFromDevelopers < ActiveRecord::Migration[7.0]
  def change
    rename_column :developers, :deveolper_name, :developer_name
  end
end
