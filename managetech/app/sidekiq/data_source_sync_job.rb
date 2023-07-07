require "uri"
require "net/http"
require "slack-notifier"

class DataSourceSyncJob
  include Sidekiq::Job

  def initialize
    @notifier = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"]
    @django_api_url = ENV["DATA_SERVER_URL"]
  end

  def perform(*args)
    ## Update channels table from data server API
    uri = URI("#{@django_api_url}/api/v1/channels/")
    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      channels = JSON.parse(res.body)["channels"]

      channels.each do |c|
        c["channel_uid"] = c["id"]
        c.delete("id")
        c.delete("created_at") if c["created_at"].blank?
        c.delete("updated_at") if c["updated_at"].blank?
      end

      # update or create all channels records by unique id
      Channel.upsert_all(channels, unique_by: [:channel_uid])
    end

    ## Update mentions table from data server API
    uri = URI("#{@django_api_url}/api/v1/mentions/")
    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      mentions = JSON.parse(res.body)["mentions"]

      mentions.each do |c|
        c.delete("sprint_uid")
        c.delete("created_at") if c["created_at"].blank?
        c.delete("updated_at") if c["updated_at"].blank?
      end

      # update or create all mentions records by unique id
      Mention.upsert_all(mentions, unique_by: [:mention_uid])
    end

    ## Update tickets table from data server API
    uri = URI("#{@django_api_url}/api/v1/tickets/")
    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      tickets = JSON.parse(res.body)["tickets"]

      tickets.each do |c|
        c.delete("sprint_uid")

        if c["difficulty"] == "Normal"
          c["difficulty"] = 1
        elsif c["difficulty"] == "Urgent"
          c["difficulty"] = 2
        else
          c["difficulty"] = 0
        end

        if c["status"] == "New" || c["status"] == "Open" || c["status"] == "To Do"
          c["status"] = "open"
        else
          c["status"] = "complete"
        end

        c.delete("created_at") if c["created_at"].blank?
        c.delete("updated_at") if c["updated_at"].blank?
      end

      # update or create all mentions records by unique id
      Ticket.upsert_all(tickets, unique_by: [:ticket_uid])
    end

    ## Update messages table from data server API
    uri = URI("#{@django_api_url}/api/v1/messages/")
    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      messages = JSON.parse(res.body)["messages"]

      messages.each do |c|
        c.delete("sprint_uid")

        c["url"] = nil if c["url"] == "_"

        c.delete("created_at") if c["created_at"].blank?
        c.delete("updated_at") if c["updated_at"].blank?
      end

      # update or create all mentions records by unique id
      Message.upsert_all(messages, unique_by: [:message_uid])
    end

    ## Update documents table from data server API
    uri = URI("#{@django_api_url}/api/v1/documents/")
    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      documents = JSON.parse(res.body)["documents"]

      documents.each do |c|
        c.delete("sprint_uid")

        c.delete("created_at") if c["created_at"].blank?
        c.delete("updated_at") if c["updated_at"].blank?
      end

      # update or create all mentions records by unique id
      Document.upsert_all(documents, unique_by: [:document_uid])
    end

    ## Update pull_requests table from data server API
    uri = URI("#{@django_api_url}/api/v1/pull-requests/")
    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      pull_requests = JSON.parse(res.body)["pull_requests"]

      pull_requests.each do |c|
        c.delete("sprint_uid")

        c.delete("created_at") if c["created_at"].blank?
        c.delete("updated_at") if c["updated_at"].blank?
      end

      # update or create all mentions records by unique id
      PullRequest.upsert_all(pull_requests, unique_by: [:pull_request_uid])
    end

    ## Update developer_project_sprints table
    # @notifier.ping "Updating developer_project_sprints table..."
    DeveloperProjectSprint.all.each do |dps|
      dps.velocity = Ticket.where(developer_id: dps.developer_id, sprint_id: dps.sprint_id, status: "complete").sum(:difficulty)
      dps.total_expected_work_hours = Ticket.where(developer_id: dps.developer_id, sprint_id: dps.sprint_id).sum(:expect_hours)
      # work_rate
      sprint_work_hours = Ticket.where(developer_id: dps.developer_id, sprint_id: dps.sprint_id, status: "complete").sum(:work_hours)
      team_ids = dps.project.teams.pluck(:id)
      team_work_hour = DeveloperTeamMap.where(developer_id: dps.developer_id, team_id: team_ids).sum(:work_hour)
      dps.work_rate = team_work_hour != 0 ? sprint_work_hours.to_f / team_work_hour.to_f * 100.to_f : 0
      dps.num_documents = Document.where(developer_id: dps.developer_id, sprint_id: dps.sprint_id).count()
      dps.num_reactions = Message.where(project_id: dps.project_id, sprint_id: dps.sprint_id, developer_id: dps.developer_id).sum(:num_reactions)
      dps.num_comments = Message.where(project_id: dps.project_id, sprint_id: dps.sprint_id, developer_id: dps.developer_id).where.not(reply_to_id: nil).count()
      dps.num_mentions = Mention.where(project_id: dps.project_id, sprint_id: dps.sprint_id).count()
      dps.avg_lead_time = Ticket.where(developer_id: dps.developer_id, sprint_id: dps.sprint_id, status: "complete").average(:work_hours) || 0
      dps.num_new_ticket = Ticket.where(developer_id: dps.developer_id, sprint_id: dps.sprint_id, create_date: dps.sprint.start_date..dps.sprint.end_date).count()
      dps.num_pull_requests = PullRequest.where(sprint_id: dps.sprint_id, developer_id: dps.developer_id).count()
      dps.num_prs_merged = PullRequest.where(sprint_id: dps.sprint_id, developer_id: dps.developer_id).where.not(merge_datetime: nil).count()
      dps.num_reviews = PullRequest.joins(:reviewers).where(sprint_id: dps.sprint_id, reviewers: { id: dps.developer_id }).count()

      prs = PullRequest.joins(:reviewers).where(sprint_id: dps.sprint_id, reviewers: { id: dps.developer_id }).where.not(merge_datetime: nil)
      dps.review_hours = prs.sum { |pr| ((pr[:merge_datetime] - pr[:create_datetime]) / 1.hour) }.round

      dps.save
    end
    # @notifier.ping "Success! - Updating developer_project_sprints table..."

    ## Update developer_projects
    # @notifier.ping "Updating developer_projects table..."
    DeveloperProject.all.each do |dp|
      dp.velocity = Ticket.where(developer_id: dp.developer_id, status: "complete").sum(:difficulty)
      dp.total_expected_work_hours = Ticket.where(developer_id: dp.developer_id).sum(:expect_hours)
      # work_rate
      project_work_hours = Ticket.where(developer_id: dp.developer_id, status: "complete").sum(:work_hours)
      team_ids = dp.project.teams.ids
      team_work_hour = DeveloperTeamMap.where(developer_id: dp.developer_id, team_id: team_ids).sum(:work_hour)
      dp.work_rate = team_work_hour != 0 ? project_work_hours.to_f / team_work_hour.to_f * 100 : 0
      dp.num_documents = Document.where(project_id: dp.project_id, developer_id: dp.developer_id).count()
      dp.num_messages = Message.where(project_id: dp.project_id, developer_id: dp.developer_id, reply_to_id: nil).count()
      dp.num_reactions = Message.where(project_id: dp.project_id, developer_id: dp.developer_id).sum(:num_reactions)
      dp.num_comments = Message.where(project_id: dp.project_id, developer_id: dp.developer_id).where.not(reply_to_id: nil).count()
      dp.num_mentions = Mention.where(project_id: dp.project_id).count()
      dp.avg_lead_time = Ticket.where(developer_id: dp.developer_id, status: "complete").average(:work_hours) || 0
      dp.num_new_ticket = Ticket.where(developer_id: dp.developer_id, project_id: dp.project_id).count()
      dp.num_pull_requests = PullRequest.where(project_id: dp.project_id, developer_id: dp.developer_id).count()
      dp.num_prs_merged = PullRequest.where(project_id: dp.project_id, developer_id: dp.developer_id).where.not(merge_datetime: nil).count()
      dp.num_reviews = PullRequest.joins(:reviewers).where(project_id: dp.project_id, reviewers: { id: dp.developer_id }).count()
      #review_hours
      prs = PullRequest.joins(:reviewers).where(project_id: dp.project_id, reviewers: { id: dp.developer_id }).where.not(merge_datetime: nil)
      dp.review_hours = prs.sum { |pr| ((pr[:merge_datetime] - pr[:create_datetime]) / 1.hour) }.round
      dp.save
    end
    # @notifier.ping "Success! - Updating developer_projects table..."

    ## Update developers
    # @notifier.ping "Updating developers table..."
    Developer.all.each do |dev|
      dev.avg_velocity = dev.developer_project_sprints.average(:velocity) || 0
      dev.avg_work_rate = dev.developer_project_sprints.average(:work_rate) || 0
      dev.num_documents = dev.documents.count
      dev.avg_lead_time = dev.developer_project_sprints.average(:avg_lead_time) || 0
      dev.avg_reviews = dev.prs.count
      dev.avg_review_hours = dev.developer_projects.average(:review_hours) || 0

      dev.save
    end
    # @notifier.ping "Sucess! - Updating developers table..."

    ## Update teams
    # @notifier.ping "Updating teams table..."
    Team.all.each do |t|
      developer_project_sprints = DeveloperProjectSprint.where(developer_id: t.developers.ids)
      t.num_members = t.developers.count
      t.avg_velocity = developer_project_sprints.average(:velocity) || 0
      t.avg_work_rate = developer_project_sprints.average(:work_rate) || 0
      t.avg_lead_time = developer_project_sprints.average(:avg_lead_time) || 0
      t.num_documents = Document.where(developer_id: t.developers.ids).count

      t.save
    end
    # @notifier.ping "Success! - Updating teams table..."

    ## Update projects
    # @notifier.ping "Updating projects table..."
    Project.all.each do |proj|
      proj.total_num_members = proj.teams.sum(:num_members)
      proj.avg_velocity = proj.teams.average(:avg_velocity) || 0
      proj.avg_work_rate = proj.teams.average(:avg_work_rate) || 0
      proj.num_documents = proj.documents.count
      proj.avg_lead_time = proj.sprints.where(status: 1).average(:velocity) || 0
      proj.num_backlog = proj.tickets.where(sprint_id: proj.backlog_sprint_id).where.not(status: "close").count
      proj.remain_work_hour = proj.avg_lead_time * proj.num_backlog
      proj.expect_release_date = DateTime.now + proj.remain_work_hour.to_i.hours
      proj.num_messages = proj.messages.where(reply_to_id: nil).count
      proj.num_reactions = proj.messages.sum(:num_reactions)
      proj.num_comments = proj.messages.where.not(reply_to_id: nil).count
      proj.num_mentions = proj.mentions.count

      proj.save
    end
    # @notifier.ping "Success! - Updating projects table..."

    ## Update Sprints
    # @notifier.ping "Updating sprints table..."
    Sprint.all.each do |sp|
      sp.num_members = Team.where(id: ProjectTeamMap.where(project_id: sp.project_id).pluck(:team_id)).sum(:num_members)
      sp.num_ticket = sp.tickets.count
      sp.num_backlog = sp.project.num_backlog
      sp.total_work_hour = sp.tickets.sum(:expect_hours)
      sp.close_work_hour = sp.tickets.where(status: "complete").sum(:expect_hours)
      sp.velocity = sp.tickets.where(status: "complete").sum(:difficulty)
      sp.avg_work_rate = sp.developer_project_sprints.average(:work_rate) || 0
      sp.num_new_ticket = sp.tickets.where(create_date: sp.start_date..sp.end_date).count
      sp.num_pull_request = sp.pull_requests.count
      sp.num_prs_merged = sp.pull_requests.where.not(merge_datetime: nil).count
      sp.num_documents = sp.documents.count
      sp.num_messages = sp.messages.where(project_id: sp.project_id, reply_to_id: nil).count
      sp.num_reactions = sp.messages.where(project_id: sp.project_id).sum(:num_reactions)
      sp.num_comments = sp.messages.where(project_id: sp.project_id).where.not(reply_to_id: nil).count
      sp.num_mentions = sp.mentions.where(project_id: sp.project_id).count

      sp.save
    end
    # @notifier.ping "Sucess! - Updating sprints table..."
  end
end
