class AddNumBacklogToSprints < ActiveRecord::Migration[7.0]
  def change
    add_column :sprints, :num_backlog, :integer
  end
end
