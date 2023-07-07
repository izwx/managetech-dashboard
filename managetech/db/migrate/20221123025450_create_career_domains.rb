class CreateCareerDomains < ActiveRecord::Migration[7.0]
  def change
    create_table :career_domains do |t|
      t.references :career
      t.references :domain
    end
  end
end
