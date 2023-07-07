class CreateDeveloperCareers < ActiveRecord::Migration[7.0]
  def change
    create_table :developer_careers do |t|
      t.references :developer, null: false
      t.date :start_month
      t.date :end_month
      t.references :project, null: false
      t.integer :role, default: DeveloperCareer.roles[:coder], comment: "参加時の役割(3:TL,2:マネージャ,1:コーダー)"

      t.index([:developer_id, :project_id], unique: true)
    end
  end
end
