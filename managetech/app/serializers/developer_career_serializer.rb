class DeveloperCareerSerializer < ActiveModel::Serializer
  attributes :id, :start_month, :end_month, :role, :developer, :project

  has_many :skills
  has_many :domains

  def developer
    {
      developer_id: object.developer.id,
      developer_name: object.developer.developer_name,
    }
  end

  def project
    {
      project_id: object.project.id,
      project_name: object.project.project_name,
    }
  end
end
