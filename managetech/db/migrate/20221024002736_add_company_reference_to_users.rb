class AddCompanyReferenceToUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :company_id
    add_reference :users, :company, index: true
  end
end
