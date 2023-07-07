class BatchLogSerializer < ActiveModel::Serializer
  attributes :id, :module, :batch_type, :content, :start_datetime, :end_datetime, :project

  belongs_to :company

  def project
    {
      id: object.project.id,
      project_name: object.project.project_name,
    }
  end
end
