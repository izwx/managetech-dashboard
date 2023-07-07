class AddDeletedAtToTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :deleted_at, :datetime
    add_index :tickets, :deleted_at
  end
end
