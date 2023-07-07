class AddUidColumnToTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :ticket_uid, :string
    add_index :tickets, :ticket_uid, unique: true
  end
end
