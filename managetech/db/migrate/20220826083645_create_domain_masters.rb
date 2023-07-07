class CreateDomainMasters < ActiveRecord::Migration[7.0]
  def change
    create_table :domain_masters do |t|
      t.references :project
      t.string :domain_name
    end
  end
end
