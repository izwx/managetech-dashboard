class CreateDomainDevelopers < ActiveRecord::Migration[7.0]
  def change
    create_table :domain_developers do |t|
      t.references :developer, null: false
      t.references :domain, null: false
      t.integer :months

      t.index([:developer_id, :domain_id], unique: true)
    end
  end
end
