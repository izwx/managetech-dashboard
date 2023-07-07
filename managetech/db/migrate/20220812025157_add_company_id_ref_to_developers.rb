class AddCompanyIdRefToDevelopers < ActiveRecord::Migration[7.0]
  def change
    remove_column :developers, :company_id, :string
    add_reference :developers, :company, index: true
  end
end
