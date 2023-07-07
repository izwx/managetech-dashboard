class DeveloperTeamMapSerializer < ActiveModel::Serializer
  attributes :id, :developer_id, :developer, :team_id, :team, :work_hour

  def developer
    {
      developer_id: object.developer.id,
      developer_name: object.developer.developer_name,
    }
  end

  def team
    {
      team_id: object.team.id,
      team_name: object.team.team_name,
    }
  end
end
