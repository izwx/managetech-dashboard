class AddDeletedAtToDomainMasters < ActiveRecord::Migration[7.0]
  def change
    add_column :domain_masters, :deleted_at, :datetime
    add_index :domain_masters, :deleted_at
  end
end
