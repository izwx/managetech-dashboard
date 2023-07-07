# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_05_02_080637) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batch_logs", force: :cascade do |t|
    t.bigint "company_id", null: false, comment: "会社ID"
    t.bigint "project_id", null: false, comment: "プロジェクトID"
    t.string "module", comment: "バッチ名"
    t.string "batch_type", comment: "error, warning, info"
    t.text "content", comment: "内容"
    t.datetime "start_datetime", comment: "開始日時"
    t.datetime "end_datetime", comment: "終了日時"
    t.datetime "deleted_at"
    t.index ["company_id"], name: "index_batch_logs_on_company_id"
    t.index ["deleted_at"], name: "index_batch_logs_on_deleted_at"
    t.index ["project_id"], name: "index_batch_logs_on_project_id"
  end

  create_table "career_domains", force: :cascade do |t|
    t.bigint "career_id"
    t.bigint "domain_id"
    t.index ["career_id"], name: "index_career_domains_on_career_id"
    t.index ["domain_id"], name: "index_career_domains_on_domain_id"
  end

  create_table "career_skills", force: :cascade do |t|
    t.bigint "career_id"
    t.bigint "skill_id"
    t.index ["career_id"], name: "index_career_skills_on_career_id"
    t.index ["skill_id"], name: "index_career_skills_on_skill_id"
  end

  create_table "channels", force: :cascade do |t|
    t.bigint "project_id", comment: "プロジェクト"
    t.bigint "tool_id", comment: "ツール"
    t.string "name", comment: "チャネル表示名"
    t.string "channel_name", comment: "ツール内でのチャネルの識別子"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "channel_uid"
    t.datetime "deleted_at"
    t.index ["channel_uid"], name: "index_channels_on_channel_uid", unique: true
    t.index ["deleted_at"], name: "index_channels_on_deleted_at"
    t.index ["project_id"], name: "index_channels_on_project_id"
    t.index ["tool_id"], name: "index_channels_on_tool_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "company_name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_companies_on_deleted_at"
  end

  create_table "developer_careers", force: :cascade do |t|
    t.bigint "developer_id", null: false
    t.date "start_month"
    t.date "end_month"
    t.bigint "project_id", null: false
    t.integer "role", default: 1, comment: "参加時の役割(3:TL,2:マネージャ,1:コーダー)"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_developer_careers_on_deleted_at"
    t.index ["developer_id", "project_id"], name: "index_developer_careers_on_developer_id_and_project_id"
    t.index ["developer_id"], name: "index_developer_careers_on_developer_id"
    t.index ["project_id"], name: "index_developer_careers_on_project_id"
  end

  create_table "developer_project_sprints", force: :cascade do |t|
    t.bigint "developer_id", null: false
    t.bigint "project_id", null: false
    t.bigint "sprint_id", null: false
    t.float "velocity", comment: "スプリントで完了させたチケットの数*チケットの難易度"
    t.float "total_expected_work_hours", comment: "予想工数の合計"
    t.float "work_rate", comment: "稼働率（完了したチケットの総工数/開発者の稼働時間の合計）"
    t.integer "num_documents", comment: "ドキュメント数"
    t.integer "num_messages", comment: "メッセージ数"
    t.integer "num_reactions", comment: "メッセージに対するリアクション数"
    t.integer "num_comments", comment: "メッセージに対するコメント数"
    t.integer "num_mentions", comment: "メンションされた数"
    t.float "avg_lead_time", comment: "完了したチケットの平均リードタイム（時間）"
    t.integer "num_new_ticket", comment: "新規チケット数"
    t.integer "num_pull_requests", comment: "プルリクエスト数"
    t.integer "num_prs_merged", comment: "マージされたプルリクエスト数"
    t.integer "num_reviews", comment: "レビュー数"
    t.float "review_hours", comment: "レビュー時間"
    t.index ["developer_id", "project_id", "sprint_id"], name: "index_developer_project_sprints", unique: true
    t.index ["developer_id"], name: "index_developer_project_sprints_on_developer_id"
    t.index ["project_id"], name: "index_developer_project_sprints_on_project_id"
    t.index ["sprint_id"], name: "index_developer_project_sprints_on_sprint_id"
  end

  create_table "developer_projects", force: :cascade do |t|
    t.bigint "developer_id", null: false
    t.bigint "project_id", null: false
    t.float "velocity", comment: "スプリントで完了させたチケットの数*チケットの難易度"
    t.float "total_expected_work_hours", comment: "予想工数の合計"
    t.float "work_rate", comment: "稼働率（完了したチケットの総工数/開発者の稼働時間の合計）"
    t.integer "num_documents", comment: "ドキュメント数"
    t.integer "num_messages", comment: "メッセージ数"
    t.integer "num_reactions", comment: "メッセージに対するリアクション数"
    t.integer "num_comments", comment: "メッセージに対するコメント数"
    t.integer "num_mentions", comment: "メンションされた数"
    t.float "avg_lead_time", comment: "完了したチケットの平均リードタイム（時間）"
    t.integer "num_new_ticket", comment: "新規チケット数"
    t.integer "num_pull_requests", comment: "プルリクエスト数"
    t.integer "num_prs_merged", comment: "マージされたプルリクエスト数"
    t.integer "num_reviews", comment: "レビュー数"
    t.float "review_hours", comment: "レビュー時間"
    t.datetime "start_date"
    t.datetime "end_date"
    t.index ["developer_id", "project_id"], name: "index_developer_projects_on_developer_id_and_project_id", unique: true
    t.index ["developer_id"], name: "index_developer_projects_on_developer_id"
    t.index ["project_id"], name: "index_developer_projects_on_project_id"
  end

  create_table "developer_team_maps", force: :cascade do |t|
    t.bigint "developer_id", null: false
    t.bigint "team_id", null: false
    t.float "work_hour"
    t.index ["developer_id", "team_id"], name: "index_developer_team_maps_on_developer_id_and_team_id", unique: true
    t.index ["developer_id"], name: "index_developer_team_maps_on_developer_id"
    t.index ["team_id"], name: "index_developer_team_maps_on_team_id"
  end

  create_table "developer_tool_maps", force: :cascade do |t|
    t.bigint "developer_id", null: false
    t.bigint "tool_id", null: false
    t.string "account_name", comment: "そのツールでの開発者のアカウント"
    t.index ["developer_id", "tool_id"], name: "index_developer_tool_maps_on_developer_id_and_tool_id", unique: true
    t.index ["developer_id"], name: "index_developer_tool_maps_on_developer_id"
    t.index ["tool_id"], name: "index_developer_tool_maps_on_tool_id"
  end

  create_table "developers", force: :cascade do |t|
    t.float "avg_velocity", comment: "平均ベロシティ"
    t.float "avg_work_rate", comment: "平均稼働率"
    t.float "num_documents", comment: "ドキュメント数"
    t.float "avg_lead_time", comment: "平均リードタイム"
    t.float "avg_reviews", comment: "レビュー数"
    t.float "avg_review_hours", comment: "平均レビュー時間"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "user_id"
    t.index ["deleted_at"], name: "index_developers_on_deleted_at"
    t.index ["user_id"], name: "index_developers_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.bigint "project_id", comment: "プロジェクト"
    t.bigint "sprint_id", comment: "スプリント"
    t.bigint "developer_id", comment: "著者"
    t.string "title", comment: "タイトル"
    t.text "contents", comment: "内容"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_uid"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_documents_on_deleted_at"
    t.index ["developer_id"], name: "index_documents_on_developer_id"
    t.index ["document_uid"], name: "index_documents_on_document_uid", unique: true
    t.index ["project_id"], name: "index_documents_on_project_id"
    t.index ["sprint_id"], name: "index_documents_on_sprint_id"
  end

  create_table "domain_developers", force: :cascade do |t|
    t.bigint "developer_id", null: false
    t.bigint "domain_id", null: false
    t.integer "months"
    t.index ["developer_id", "domain_id"], name: "index_domain_developers_on_developer_id_and_domain_id", unique: true
    t.index ["developer_id"], name: "index_domain_developers_on_developer_id"
    t.index ["domain_id"], name: "index_domain_developers_on_domain_id"
  end

  create_table "domain_masters", force: :cascade do |t|
    t.bigint "project_id"
    t.string "domain_name"
    t.bigint "creater_id", null: false
    t.datetime "deleted_at"
    t.index ["creater_id"], name: "index_domain_masters_on_creater_id"
    t.index ["deleted_at"], name: "index_domain_masters_on_deleted_at"
    t.index ["project_id"], name: "index_domain_masters_on_project_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "mentions", force: :cascade do |t|
    t.bigint "message_id", comment: "メッセージ"
    t.bigint "project_id", comment: "プロジェクト"
    t.bigint "sprint_id", comment: "スプリント"
    t.integer "mention_to", comment: "メンション先がdeveloper_idを持っていればレコードを作成"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mention_uid"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_mentions_on_deleted_at"
    t.index ["mention_uid"], name: "index_mentions_on_mention_uid", unique: true
    t.index ["message_id"], name: "index_mentions_on_message_id"
    t.index ["project_id"], name: "index_mentions_on_project_id"
    t.index ["sprint_id"], name: "index_mentions_on_sprint_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "developer_id", comment: "発言者"
    t.bigint "project_id", comment: "プロジェクト"
    t.bigint "sprint_id", comment: "スプリント"
    t.bigint "reply_to_id", comment: "どのメッセージへのコメントか。親メッセージならnull"
    t.string "channel_uid", comment: "チャネル名"
    t.string "url"
    t.string "contents"
    t.integer "num_reactions", comment: "リアクションの数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message_uid"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_messages_on_deleted_at"
    t.index ["developer_id"], name: "index_messages_on_developer_id"
    t.index ["message_uid"], name: "index_messages_on_message_uid", unique: true
    t.index ["project_id"], name: "index_messages_on_project_id"
    t.index ["reply_to_id"], name: "index_messages_on_reply_to_id"
    t.index ["sprint_id"], name: "index_messages_on_sprint_id"
  end

  create_table "project_team_maps", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "team_id", null: false
    t.index ["project_id", "team_id"], name: "index_project_team_maps_on_project_id_and_team_id", unique: true
    t.index ["project_id"], name: "index_project_team_maps_on_project_id"
    t.index ["team_id"], name: "index_project_team_maps_on_team_id"
  end

  create_table "project_tool_infos", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "tool_id", null: false
    t.string "token", comment: "APIアクセス用のTokenやパスワードを想定"
    t.string "target", comment: "SlackのチャネルやJiraのプロジェクト、Gitのリポジトリ名などを想定"
    t.string "payload", comment: "その他のデータ"
    t.index ["project_id", "tool_id"], name: "index_project_tool_infos_on_project_id_and_tool_id", unique: true
    t.index ["project_id"], name: "index_project_tool_infos_on_project_id"
    t.index ["tool_id"], name: "index_project_tool_infos_on_tool_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "project_name", null: false
    t.integer "project_phase", comment: "3:新規,2:改修,1:運用"
    t.integer "sprint_week", comment: "1スプリントは何週間か"
    t.integer "backlog_sprint_id", comment: "バックログを示すsprint_id"
    t.integer "current_sprint_order", comment: "現在のスプリント名（指定なければスプリント番号）"
    t.integer "project_status", default: 0, comment: "0:Inactive,1:Active"
    t.integer "total_num_members", comment: "メンバ数"
    t.float "avg_velocity", comment: "平均ベロシティ"
    t.float "avg_work_rate", comment: "平均稼働率"
    t.integer "num_documents", comment: "ドキュメント数"
    t.float "avg_lead_time", comment: "平均リードタイム"
    t.float "remain_work_hour", comment: "平均リードタイム×残バックログ"
    t.date "expect_release_date", comment: "終了予想日(平均リードタイム×残バックログから予想"
    t.integer "num_backlog", comment: "残バックログ"
    t.integer "num_messages", comment: "メッセージ数"
    t.integer "num_reactions", comment: "メッセージに対するリアクション数"
    t.integer "num_comments", comment: "メッセージに対するコメント数"
    t.integer "num_mentions", comment: "メンションされた数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_company_id", comment: "顧客の会社ID"
    t.datetime "deleted_at"
    t.index ["company_id"], name: "index_projects_on_company_id"
    t.index ["deleted_at"], name: "index_projects_on_deleted_at"
  end

  create_table "pull_request_reviewers", force: :cascade do |t|
    t.bigint "pr_id"
    t.bigint "reviewer_id"
    t.index ["pr_id"], name: "index_pull_request_reviewers_on_pr_id"
    t.index ["reviewer_id"], name: "index_pull_request_reviewers_on_reviewer_id"
  end

  create_table "pull_requests", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "sprint_id"
    t.bigint "developer_id", comment: "担当者"
    t.string "title", comment: "タイトル"
    t.integer "num_comments", comment: "コメント数"
    t.text "contents", comment: "内容"
    t.datetime "create_datetime", comment: "作成日時"
    t.datetime "merge_datetime", comment: "マージ日時（完了してなければnull）"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pull_request_uid"
    t.string "url", comment: "元々のプルリクエストを表示するためのURL"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_pull_requests_on_deleted_at"
    t.index ["developer_id"], name: "index_pull_requests_on_developer_id"
    t.index ["project_id"], name: "index_pull_requests_on_project_id"
    t.index ["pull_request_uid"], name: "index_pull_requests_on_pull_request_uid", unique: true
    t.index ["sprint_id"], name: "index_pull_requests_on_sprint_id"
  end

  create_table "skill_developers", force: :cascade do |t|
    t.bigint "developer_id", null: false
    t.bigint "skill_id", null: false
    t.integer "months"
    t.index ["developer_id", "skill_id"], name: "index_skill_developers_on_developer_id_and_skill_id", unique: true
    t.index ["developer_id"], name: "index_skill_developers_on_developer_id"
    t.index ["skill_id"], name: "index_skill_developers_on_skill_id"
  end

  create_table "skill_masters", force: :cascade do |t|
    t.bigint "project_id"
    t.string "skill_name"
    t.bigint "creater_id", null: false
    t.datetime "deleted_at"
    t.index ["creater_id"], name: "index_skill_masters_on_creater_id"
    t.index ["deleted_at"], name: "index_skill_masters_on_deleted_at"
    t.index ["project_id"], name: "index_skill_masters_on_project_id"
  end

  create_table "sprints", force: :cascade do |t|
    t.string "name", comment: "スプリント名(Jira-Sprint-スプリント名)"
    t.bigint "project_id", null: false, comment: "スプリント名(Jira-Sprint-プロジェクト)"
    t.date "start_date", comment: "開始日(Jira-Sprint-開始日)"
    t.date "end_date", comment: "開始日(Jira-Sprint-開始日)"
    t.integer "status", comment: "スプリントが完了したかどうか（終了日を過ぎたか）"
    t.integer "order"
    t.integer "num_members", comment: "チーム人数"
    t.integer "num_ticket", comment: "チケット数"
    t.integer "num_backlog", comment: "バックログ数"
    t.float "total_work_hour", comment: "総工数"
    t.float "close_work_hour", comment: "完了工数"
    t.float "velocity", comment: "ベロシティ"
    t.float "avg_work_rate", comment: "平均稼働率"
    t.integer "num_new_ticket", comment: "新規チケット数"
    t.integer "num_pull_request", comment: "プルリク数"
    t.integer "num_prs_merged", comment: "マージ済PR数"
    t.integer "num_documents", comment: "ドキュメント数"
    t.integer "num_messages", comment: "メッセージ数"
    t.integer "num_reactions", comment: "メッセージに対するリアクション数"
    t.integer "num_comments", comment: "メッセージに対するコメント数"
    t.integer "num_mentions", comment: "メンションされた数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sprint_uid"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_sprints_on_deleted_at"
    t.index ["project_id"], name: "index_sprints_on_project_id"
    t.index ["sprint_uid"], name: "index_sprints_on_sprint_uid", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "team_name", default: "", null: false
    t.integer "num_members", comment: "メンバ数"
    t.float "avg_velocity", comment: "平均ベロシティ"
    t.float "avg_work_rate", comment: "平均稼働率"
    t.float "avg_lead_time", comment: "平均リードタイム"
    t.integer "num_documents", comment: "ドキュメント数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.datetime "deleted_at"
    t.index ["company_id"], name: "index_teams_on_company_id"
    t.index ["deleted_at"], name: "index_teams_on_deleted_at"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "developer_id", comment: "担当者"
    t.bigint "project_id"
    t.bigint "sprint_id"
    t.string "title"
    t.string "url"
    t.string "status", comment: "ステータス"
    t.datetime "start_date", comment: "開始日"
    t.integer "expect_hours", comment: "予想工数"
    t.integer "work_hours", comment: "作業工数"
    t.datetime "end_date", comment: "完了日"
    t.datetime "create_date", comment: "チケット作成日"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "difficulty", comment: "難易度"
    t.string "ticket_uid"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_tickets_on_deleted_at"
    t.index ["developer_id"], name: "index_tickets_on_developer_id"
    t.index ["project_id"], name: "index_tickets_on_project_id"
    t.index ["sprint_id"], name: "index_tickets_on_sprint_id"
    t.index ["ticket_uid"], name: "index_tickets_on_ticket_uid", unique: true
  end

  create_table "tool_masters", force: :cascade do |t|
    t.string "tool_name", null: false
    t.string "token_guide"
    t.string "target_guide"
    t.string "payload_guide"
    t.string "account_name_guide"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_tool_masters_on_deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "role", comment: "経営層、顧客、プロジェクトマネージャ、開発者、Managetech Admin"
    t.integer "status", default: 0, comment: "0:仮登録, 1:アクティブ, 2:停止"
    t.datetime "register_date", comment: "登録日時"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.bigint "company_id"
    t.datetime "deleted_at"
    t.string "avatar_url"
    t.string "name"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end


  create_view "team_view", sql_definition: <<-SQL
      SELECT teams.id,
      teams.team_name,
      teams.company_id,
      count(dtm.developer_id) AS num_members,
      avg(dps.velocity) AS avg_velocity,
      avg(dps.work_rate) AS avg_work_rate,
      avg(dps.avg_lead_time) AS avg_lead_time,
      count(d.id) AS num_documents
     FROM (teams
       LEFT JOIN ((developer_team_maps dtm
       JOIN developer_project_sprints dps ON ((dps.developer_id = dtm.developer_id)))
       JOIN documents d ON ((d.developer_id = dtm.developer_id))) ON ((teams.id = dtm.team_id)))
    GROUP BY teams.id;
  SQL
  create_view "developer_team_view", sql_definition: <<-SQL
      SELECT dtm.developer_id,
      dtm.team_id,
      dtm.work_hour,
      count(d.developer_id) AS num_document,
      avg(dps.velocity) AS avg_velocity,
      avg(dps.work_rate) AS avg_work_rate,
      avg(dps.avg_lead_time) AS avg_lead_time,
      count(d.developer_id) AS num_document_1,
      sum(
          CASE
              WHEN (d.id IS NOT NULL) THEN 1
              ELSE 0
          END) AS document_count
     FROM ((developer_team_maps dtm
       LEFT JOIN developer_project_sprints dps ON ((dps.developer_id = dtm.developer_id)))
       LEFT JOIN documents d ON ((d.developer_id = dtm.developer_id)))
    GROUP BY dtm.team_id, dtm.developer_id, dtm.work_hour;
  SQL
  create_view "team_1", sql_definition: <<-SQL
      SELECT t.id,
      t.team_name,
      t.company_id,
      sum(d.developer_id) AS num_documents
     FROM (teams t
       LEFT JOIN (developer_team_maps dtm
       LEFT JOIN documents d ON ((dtm.developer_id = d.developer_id))) ON ((dtm.team_id = t.id)))
    GROUP BY t.id, t.team_name, t.company_id;
  SQL
  create_view "new_team_view", sql_definition: <<-SQL
      WITH developer_team_view AS (
           SELECT dtm.developer_id,
              dtm.team_id,
              dtm.work_hour,
              count(d.developer_id) AS num_document
             FROM (developer_team_maps dtm
               LEFT JOIN documents d ON ((dtm.developer_id = d.developer_id)))
            GROUP BY dtm.team_id, dtm.developer_id, dtm.work_hour
          )
   SELECT t.id,
      t.team_name,
      t.company_id,
      count(dtv.developer_id) AS num_members,
      sum(dtv.num_document) AS num_documents
     FROM (teams t
       LEFT JOIN developer_team_view dtv ON ((dtv.team_id = t.id)))
    GROUP BY t.id;
  SQL
  create_view "dtm_view", sql_definition: <<-SQL
      SELECT dtm.developer_id,
      dtm.team_id,
      dtm.work_hour,
      count(d.developer_id) AS num_document,
      avg(dps.velocity) AS avg_velocity,
      avg(dps.work_rate) AS avg_work_rate,
      avg(dps.avg_lead_time) AS avg_lead_time,
      count(d.developer_id) AS num_document_1,
      sum(
          CASE
              WHEN (d.developer_id IS NOT NULL) THEN 1
              ELSE 0
          END) AS document_count
     FROM ((developer_team_maps dtm
       LEFT JOIN developer_project_sprints dps ON ((dps.developer_id = dtm.developer_id)))
       LEFT JOIN documents d ON ((d.developer_id = dtm.developer_id)))
    GROUP BY dtm.team_id, dtm.developer_id, dtm.work_hour;
  SQL
  create_view "dtm_d_view", sql_definition: <<-SQL
      SELECT dtm.team_id,
      dtm.developer_id,
      dtm.work_hour,
      sum(
          CASE
              WHEN (d.developer_id IS NOT NULL) THEN 1
              ELSE 0
          END) AS document_count
     FROM (developer_team_maps dtm
       LEFT JOIN documents d ON ((d.developer_id = dtm.developer_id)))
    GROUP BY dtm.team_id, dtm.developer_id, dtm.work_hour;
  SQL
  create_view "dtm_dc_view", sql_definition: <<-SQL
      SELECT dtm.team_id,
      dtm.developer_id,
      dtm.work_hour,
      sum(
          CASE
              WHEN (dc.developer_id IS NOT NULL) THEN 1
              ELSE 0
          END) AS developer_careers_count
     FROM (developer_team_maps dtm
       LEFT JOIN developer_careers dc ON ((dc.developer_id = dtm.developer_id)))
    GROUP BY dtm.team_id, dtm.developer_id, dtm.work_hour;
  SQL
  create_view "dtm_d_dc_view", sql_definition: <<-SQL
      SELECT dtm.team_id,
      dtm.developer_id,
      dtm.work_hour,
      sum(
          CASE
              WHEN (dc.developer_id IS NOT NULL) THEN 1
              ELSE 0
          END) AS developer_careers_count,
      sum(
          CASE
              WHEN (d.developer_id IS NOT NULL) THEN 1
              ELSE 0
          END) AS documents_count
     FROM ((developer_team_maps dtm
       LEFT JOIN documents d ON ((d.developer_id = dtm.developer_id)))
       LEFT JOIN developer_careers dc ON ((dc.developer_id = dtm.developer_id)))
    GROUP BY dtm.team_id, dtm.developer_id, dtm.work_hour;
  SQL
end
