class CreateSkillDevelopers < ActiveRecord::Migration[7.0]
  def change
    create_table :skill_developers do |t|
      t.references :developer, null: false
      t.references :skill, null: false
      t.integer :months

      t.index([:developer_id, :skill_id], unique: true)
    end
  end
end
