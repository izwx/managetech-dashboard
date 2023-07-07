class AddClientCompanyIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :client_company_id, :integer, comment: "顧客の会社ID"
  end
end
