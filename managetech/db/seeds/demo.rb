# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "faker"
require "securerandom"

print "...Seeding is starting!..."

## Seed Company Table
Company.with_deleted.all.each do |c|
  c.really_destroy!
end
companies_list = ["株式会社高橋興業", "株式会社真栄", "有限会社大喜", "株式会社シンワ", "株式会社BONDS"]
5.times do |index|
  Company.create!(
    id: index + 1,
    company_name: companies_list[index],
    created_at: Faker::Time.between(from: DateTime.now - 6.months, to: DateTime.now - 1.months),
    updated_at: Faker::Time.between(from: DateTime.now - 1.months, to: DateTime.now),
  )
end

## Seed Developers Table
Developer.with_deleted.all.each do |d|
  d.really_destroy!
end
User.with_deleted.where(role: "developer").where.not(email: "developer@managetech.io").each do |u|
  u.really_destroy!
end
names_list = [
  "大下環",
  "塚本友子",
  "川野環菜",
  "本田秀樹",
  "植木奈緒子",
  "久保絵里",
  "黒岩玲菜",
  "福井貴史",
  "植木忠広",
  "真野淳三",
  "小村果凛",
  "西尾天音",
  "上野博昭",
  "竹田俊哉",
  "梅原定雄",
  "守屋詩乃",
  "東山和歌子",
  "太田凪紗",
  "深谷宏明",
  "三原春奈",
  "堀田英紀",
  "長谷川嘉男",
  "金城朝仁",
  "二瓶栄三郎",
  "仲野莉津香",
  "吉永麻美",
  "玉井正義",
  "細川曜子",
  "保坂拓也",
  "宮原和恵",
  "落合咲子",
  "神谷和泉",
  "神谷和泉",
  "高井昭子",
  "小池和夫",
  "小池和夫",
  "永井みさ",
  "岡由恵",
  "山根恵子",
  "吉本美貴",
  "宮田由加",
  "黒木真里",
  "橘春奈",
  "広瀬太",
  "奈良祐介",
  "豊田智史",
  "大平章子",
  "江藤良太",
  "二宮健二",
  "小西有貴",
]
50.times do |i|
  company = Company.all.sample
  dev_user = User.create!(
    email: "#{Faker::Internet.user_name}@managetech.io",
    name: names_list[i],
    role: "developer",
    company: company,
    status: User.statuses[:active],
  )
  Developer.create!(
    user: dev_user,
    avg_velocity: rand(2.0..10.0),
    avg_work_rate: rand(2.0..10.0),
    num_documents: rand(2..10),
    avg_lead_time: rand(3..15),
    avg_reviews: rand(3..20),
    avg_review_hours: rand(10..48),
    created_at: Faker::Time.between(from: DateTime.now - 6.months, to: DateTime.now - 1.months),
    updated_at: Faker::Time.between(from: DateTime.now - 1.months, to: DateTime.now),
  )
end

## Create developer@projectmanagement.io developer
du = User.where(email: "developer@managetech.io").first
Developer.create!(
  user: du,
  avg_velocity: rand(2.0..10.0),
  avg_work_rate: rand(2.0..10.0),
  num_documents: rand(2..10),
  avg_lead_time: rand(3..15),
  avg_reviews: rand(3..20),
  avg_review_hours: rand(10..48),
  created_at: Faker::Time.between(from: DateTime.now - 6.months, to: DateTime.now - 1.months),
  updated_at: Faker::Time.between(from: DateTime.now - 1.months, to: DateTime.now),
)

## Seed Team Table
Team.with_deleted.all.each do |t|
  t.really_destroy!
end
DeveloperTeamMap.destroy_all
teams_list = ["WEB開発チーム-1", "ANDROID開発チーム-1", "iOS開発チーム-1", "Q&Aチーム-1", "techOpsチーム-1", "WEB開発チーム-2", "ANDROID開発チーム-2", "iOS開発チーム-2", "Q&Aチーム-2", "techOpsチーム-2"]
10.times do |index|
  team = Team.create!(
    id: index + 1,
    team_name: teams_list[index],
    company: Company.all.sample,
    num_members: rand(2..10),
    avg_velocity: rand(2.0..10.0),
    avg_work_rate: rand(2.0..10.0),
    avg_lead_time: rand(3..15),
    num_documents: rand(2..10),
  )
  team.developers << Developer.all.sample(5)
end

DeveloperTeamMap.all.each do |dev_team|
  dev_team.update(work_hour: rand(20..40))
end

## Seed project table
Project.with_deleted.all.each do |t|
  t.really_destroy!
end
DeveloperProject.destroy_all
ProjectTeamMap.destroy_all
10.times do |index|
  project = Project.create!(
    id: index + 1,
    company: Company.all.sample,
    project_name: Faker::App.name + "プロジェクト",
    project_phase: rand(1..3),
    project_status: 1,
    sprint_week: rand(1..2),
    current_sprint_order: rand(1..5),
    backlog_sprint_id: rand(1..25),
    created_at: Faker::Time.between(from: DateTime.now - 6.months, to: DateTime.now - 1.months),
    updated_at: Faker::Time.between(from: DateTime.now - 1.months, to: DateTime.now),
    client_company: Company.all.sample,
    total_num_members: rand(5..15),
    avg_velocity: rand(1.0..10.0),
    avg_work_rate: rand(1.0..10.0),
    num_documents: rand(2..15),
    avg_lead_time: rand(3..15),
    remain_work_hour: rand(10..50),
    expect_release_date: Faker::Time.between(from: DateTime.now - 10, to: DateTime.now),
    num_backlog: rand(5..10),
    num_messages: rand(1..50),
    num_reactions: rand(1..50),
    num_comments: rand(1..50),
    num_mentions: rand(1..50),
  )
  team = Team.all.sample
  project.teams << team
  project.developers << team.developers.all
end

# Add all teams to project_team_maps
Team.all.each do |t|
  existing_project_ids = ProjectTeamMap.where(team_id: t.id).pluck(:project_id)
  all_project_ids = Project.all.ids
  available_projects_ids = all_project_ids - existing_project_ids

  unless ProjectTeamMap.where(team_id: t.id).exists?
    ProjectTeamMap.create!(
      team_id: t.id,
      project_id: available_projects_ids.sample,
    )
  end
end

## Seed developer_project table
DeveloperProject.all.each do |dp|
  dp.update(
    velocity: rand(1.0..10.0),
    total_expected_work_hours: rand(10..60),
    work_rate: rand(1.0..10.0),
    num_documents: rand(1..10),
    num_messages: rand(1..30),
    num_reactions: rand(1..30),
    num_comments: rand(1..30),
    num_mentions: rand(1..30),
    avg_lead_time: rand(1.0..10.0),
    num_new_ticket: rand(1..30),
    num_pull_requests: rand(1..30),
    num_prs_merged: rand(1..30),
    num_reviews: rand(1..30),
    review_hours: rand(1..50),
  )
end

## Seed Sprints table
Sprint.with_deleted.all.each do |t|
  t.really_destroy!
end
Project.all.each do |project|
  15.times do |index|
    Sprint.create!(
      name: Faker::App.name,
      project: project,
      order: index,
      start_date: Faker::Time.between(from: DateTime.now - 10, to: DateTime.now),
      end_date: Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 20),
      status: rand(0..1),
      num_members: rand(1..5),
      num_ticket: rand(1..10),
      num_backlog: rand(1..5),
      total_work_hour: rand(1..36),
      close_work_hour: rand(1..24),
      velocity: rand(1.0..10.0),
      avg_work_rate: rand(1.0..10.0),
      num_new_ticket: rand(1..10),
      num_pull_request: rand(1..5),
      num_prs_merged: rand(1..5),
      num_documents: rand(1..5),
      num_messages: rand(1..30),
      num_reactions: rand(1..30),
      num_comments: rand(1..30),
      num_mentions: rand(1..30),
    )
  end
end

DeveloperProjectSprint.destroy_all
DeveloperProject.all.each do |developer_project|
  developer = developer_project.developer
  project = developer_project.project
  sprints = project.sprints.all

  sprints.each do |sprint|
    DeveloperProjectSprint.create!(
      developer: developer,
      project: project,
      sprint: sprint,
      velocity: rand(1.0..10.0),
      total_expected_work_hours: rand(10..60),
      work_rate: rand(1.0..10.0),
      num_documents: rand(1..10),
      num_messages: rand(1..30),
      num_reactions: rand(1..30),
      num_comments: rand(1..30),
      num_mentions: rand(1..30),
      avg_lead_time: rand(1.0..10.0),
      num_new_ticket: rand(1..30),
      num_pull_requests: rand(1..30),
      num_prs_merged: rand(1..30),
      num_reviews: rand(1..30),
      review_hours: rand(1..50),
    )
  end
end

## Seed skill_master table data
SkillMaster.with_deleted.all.each do |t|
  t.really_destroy!
end
Project.all.each do |sp|
  10.times do
    SkillMaster.create!(
      project: sp,
      skill_name: Faker::ProgrammingLanguage.name,
      creater: User.all.sample,
    )
  end
end

## Seed skill developers
Developer.all.each do |dev|
  SkillMaster.all.sample(5).each do |skill|
    dev.skill_developers.build(skill_id: skill.id, months: rand(5..20))
  end
  dev.save
end

## Seed domain_master table data
DomainMaster.with_deleted.all.each do |t|
  t.really_destroy!
end
Project.all.each do |sp|
  10.times do
    DomainMaster.create!(
      project: sp,
      domain_name: Faker::ProgrammingLanguage.name,
      creater: User.all.sample,
    )
  end
end

## Seed domain developers
Developer.all.each do |dev|
  DomainMaster.all.sample(5).each do |domain|
    dev.domain_developers.build(domain_id: domain.id, months: rand(5..20))
  end
  dev.save
end

## Seed batch_logs table
BatchLog.with_deleted.all.each do |t|
  t.really_destroy!
end
20.times do
  BatchLog.create!(
    company: Company.all.sample,
    project: Project.all.sample,
    module: Faker::Code.asin,
    batch_type: ["error", "warning", "info"].sample,
    content: Faker::Hipster.sentence(word_count: 3, supplemental: true),
    start_datetime: Faker::Time.between(from: DateTime.now - 30, to: DateTime.now),
    end_datetime: Faker::Time.between(from: DateTime.now - 30, to: DateTime.now),
  )
end

## Seed tool_masters table
ToolMaster.with_deleted.all.each do |t|
  t.really_destroy!
end
ToolMaster.create!(
  [
    { tool_name: "Jira" },
    { tool_name: "Slack" },
    { tool_name: "Trello" },
    { tool_name: "Chatwork" },
    { tool_name: "Github" },
    { tool_name: "Gitlab" },
    { tool_name: "Redmine" },
  ]
)

## Seed developer_career table
DeveloperCareer.with_deleted.all.each do |t|
  t.really_destroy!
end
50.times do |index|
  project = Project.all.sample
  developer = Developer.all.sample
  developer_career = DeveloperCareer.where(developer: developer, project: project).first_or_initialize
  developer_career.start_month = Faker::Time.between(from: DateTime.now - 360, to: DateTime.now - 240)
  developer_career.end_month = Faker::Time.between(from: DateTime.now - 180, to: DateTime.now - 60)
  developer_career.role = [1, 2, 3].sample
  developer_career.save
end

## Seed project tool info
ProjectToolInfo.destroy_all
30.times do
  project = Project.all.sample
  tool = ToolMaster.all.sample
  project_tool_info = ProjectToolInfo.where(project_id: project.id, tool_id: tool.id).first_or_initialize
  project_tool_info.token = Faker::Internet.device_token
  project_tool_info.target = Faker::Restaurant.name
  project_tool_info.payload = Faker::Internet.uuid
  project_tool_info.save
end

## Seed tickets table
Ticket.with_deleted.all.each do |t|
  t.really_destroy!
end
Project.all.each do |project|
  sprints = project.sprints
  developers = project.developers
  sprints.each do |sprint|
    (5..10).to_a.sample.times do
      Ticket.create!(
        developer: developers.sample,
        project: project,
        sprint: sprint,
        title: Faker::App.name,
        url: Faker::Internet.url,
        status: ["open", "close", "complete"].sample,
        # easy:0, normal:1, hard:2
        difficulty: ["0", "1", "2"].sample,
        start_date: Faker::Time.between(from: DateTime.now - 60, to: DateTime.now - 50),
        expect_hours: rand(5..20),
        work_hours: rand(1..40),
        end_date: Faker::Time.between(from: DateTime.now - 49, to: DateTime.now - 35),
        create_date: Faker::Time.between(from: DateTime.now - 60, to: DateTime.now - 50),
        ticket_uid: SecureRandom.uuid,
      )
    end
  end
end

## Seed pull requests
PullRequest.with_deleted.all.each do |t|
  t.really_destroy!
end
Project.all.each do |project|
  sprints = project.sprints
  developers = project.developers
  sprints.each do |sprint|
    (5..10).to_a.sample.times do
      PullRequest.create!(
        project: project,
        sprint: sprint,
        developer: developers.sample,
        title: Faker::App.name,
        url: Faker::Internet.url,
        num_comments: rand(3..10),
        contents: Faker::Lorem.sentence(word_count: 5),
        create_datetime: Faker::Time.between(from: DateTime.now - 60, to: DateTime.now - 50),
        merge_datetime: Faker::Time.between(from: DateTime.now - 49, to: DateTime.now - 35),
        pull_request_uid: SecureRandom.uuid,
      )
    end
  end
end

## Seed developer_tool_map table
DeveloperToolMap.destroy_all
Developer.all.each do |developer|
  tools = ToolMaster.all.sample(2)
  developer.tools << tools
  developer.developer_tool_maps.each do |dtm|
    user = Faker::Internet.user
    dtm.account_name = user[:username]
    dtm.save
  end
  developer.save
end

PullRequestReviewer.destroy_all
PullRequest.all.each do |pr|
  reviewers = Developer.all.sample([1, 2].sample)
  pr.reviewers << reviewers
  pr.save
end

## Documents seed
Document.with_deleted.all.each do |t|
  t.really_destroy!
end
Project.all.each do |project|
  3.times do
    sprint = project.sprints.sample
    developer = project.developers.sample
    document = Document.where(project: project, sprint: sprint, developer: developer).first_or_initialize
    document.title = Faker::App.name
    document.contents = Faker::Lorem.sentence(word_count: 5)
    document.document_uid = SecureRandom.uuid
    document.save
  end
end

print "...Congratulations!🎉🎉 Seeding compeleted!..."
