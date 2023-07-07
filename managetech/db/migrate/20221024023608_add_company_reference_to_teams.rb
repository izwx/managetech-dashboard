class AddCompanyReferenceToTeams < ActiveRecord::Migration[7.0]
  def change
    add_reference :teams, :company, index: true
  end
end
