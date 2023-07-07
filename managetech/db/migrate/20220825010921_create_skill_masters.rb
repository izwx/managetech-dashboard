class CreateSkillMasters < ActiveRecord::Migration[7.0]
  def change
    create_table :skill_masters do |t|
      t.references :project
      t.string :skill_name
    end
  end
end
