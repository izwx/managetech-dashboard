class AddCreaterToDomainMaster < ActiveRecord::Migration[7.0]
  def change
    add_reference :domain_masters, :creater, references: :users, null: false, index: true
  end
end
