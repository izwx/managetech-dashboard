class AddDeletedAtToSkillMasters < ActiveRecord::Migration[7.0]
  def change
    add_column :skill_masters, :deleted_at, :datetime
    add_index :skill_masters, :deleted_at
  end
end
