class TicketsColumnsNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tickets, :developer_id, true
    change_column_null :tickets, :project_id, true
    change_column_null :tickets, :sprint_id, true
  end
end
