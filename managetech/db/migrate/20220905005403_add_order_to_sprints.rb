class AddOrderToSprints < ActiveRecord::Migration[7.0]
  def change
    add_column :sprints, :order, :integer
  end
end
