class UpdateDeveloperCareer
  include Sidekiq::Job

  def initialize
  end

  def perform(*args)
    ## team_projectからdeveloper_projectの作成
    ProjectTeamMap.includes(:team).all.each do |tp|
      team_devs = tp.team.developers
      team_devs.each do |td|
        if !DeveloperProject.where(developer_id: td.id, project_id: tp.project_id).exists?
          new_dp = DeveloperProject.new
          new_dp.developer_id = td.id
          new_dp.project_id = tp.project_id
          new_dp.save
        end
      end
    end

    ## developer_careerの作成と更新
    @developer_projects = DeveloperProject.includes(:project).all
    @developer_projects.each do |dev_project|
      dev_career = DeveloperCareer.where(developer_id: dev_project.developer_id, project_id: dev_project.project_id)
      ## developer_careerがなければ新しいレコードを作成し、developer_careerがあればprojectのstatusがinactiveの時にend_monthだけを更新する。
      if !dev_career.exists?
        new_dev_career = DeveloperCareer.new
        new_dev_career.developer_id = dev_project.developer_id
        new_dev_career.project_id = dev_project.project_id
        new_dev_career.start_month = DateTime.now
        new_dev_career.save
      else
        if dev_project.project.project_status == "inactive"
          dev_career.update(end_month: DateTime.now)
        end
      end
    end

    DeveloperCareer.all.each do |career|
      start_time = career.start_month
      end_time = career.end_month ? career.end_month : DateTime.now
      current = DateTime.now
      ## skill_developersのテーブルを更新する
      if career.skills.exists?
        career.skills.each do |cskill|
          dev_skill = SkillDeveloper.where(developer_id: career.developer_id, skill_id: cskill.id).first_or_initialize
          dev_skill.months = ((end_time.year - start_time.year) * 12 + end_time.month - start_time.month) * DeveloperCareer.roles[career.role] - ((current.year - end_time.year) * 12 + current.month - end_time.month) / 2
          dev_skill.save
        end
      end

      ## domain_developersのテーブルを更新する
      if career.domains.exists?
        career.domains.each do |cdomain|
          dev_domain = DomainDeveloper.where(developer_id: career.developer_id, domain_id: cdomain.id).first_or_initialize
          dev_domain.months = ((end_time.year - start_time.year) * 12 + end_time.month - start_time.month) * DeveloperCareer.roles[career.role] - ((current.year - end_time.year) * 12 + current.month - end_time.month) / 2
          dev_domain.save
        end
      end
    end
  end
end
