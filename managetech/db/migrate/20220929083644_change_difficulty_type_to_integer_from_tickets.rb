class ChangeDifficultyTypeToIntegerFromTickets < ActiveRecord::Migration[7.0]
  def change
    remove_column :tickets, :difficulty, :string, comment: "難易度"
    add_column :tickets, :difficulty, :integer, comment: "難易度"
  end
end
