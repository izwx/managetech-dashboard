class AddCreaterToSkillMaster < ActiveRecord::Migration[7.0]
  def change
    add_reference :skill_masters, :creater, references: :users, null: false, index: true
  end
end
