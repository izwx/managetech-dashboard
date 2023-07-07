class ProjectToolInfoSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :project, :tool_id, :tool, :token, :target, :payload

  def project
    {
      project_id: object.project.id,
      project_name: object.project.project_name,
    }
  end

  def tool
    {
      tool_id: object.tool_master.id,
      tool_name: object.tool_master.tool_name,
    }
  end
end
