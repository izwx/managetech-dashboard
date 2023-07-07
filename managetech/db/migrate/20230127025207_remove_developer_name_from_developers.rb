class RemoveDeveloperNameFromDevelopers < ActiveRecord::Migration[7.0]
  def change
    remove_column :developers, :developer_name, :string
    remove_reference :developers, :company, index: true
    add_reference :developers, :user, index: true
  end
end
