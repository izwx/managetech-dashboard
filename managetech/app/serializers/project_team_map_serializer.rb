class ProjectTeamMapSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :project, :team_id, :team

  def project
    {
      project_id: object.project.id,
      project_name: object.project.project_name,
    }
  end

  def team
    {
      team_id: object.team.id,
      team_name: object.team.team_name,
    }
  end
end
