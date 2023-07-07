class SkillMasterSerializer < ActiveModel::Serializer
  attributes :id, :skill_name, :project, :creater

  def project
    {
      project_id: object.project.id,
      project_name: object.project.project_name,
    }
  end

  def creater
    {
      user_id: object.creater ? object.creater.id : nil,
      email: object.creater ? object.creater.email : nil,
      role: object.creater ? object.creater.role : nil,
    }
  end
end
