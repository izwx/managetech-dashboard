class CreateCareerSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :career_skills do |t|
      t.references :career
      t.references :skill
    end
  end
end
