## DB Table Definition

We included the definition of the database tables for the developer’s convenience to help them understand the DB schema and DB queries we are using for statistic and graphic data

| companies |  |
| --- | --- |
|  | id |
|  | company_name |

| users |  |  |
| --- | --- | --- |
|  | id |  |
|  | company_id | Company ID |
|  | e_mail | Account Email Address |
|  | name | Username |
|  | password_hash | Password hash |
|  | role | Executive, Customer, Project Manager, Developer, Managetech Admin |
|  | status | Temporary, Active, Deactivated |
|  | register_date | Registration Date |
|  | last_login | Last login |
|  | avatar_url | avatar url |

| projects |  |  |  |
| --- | --- | --- | --- |
|  | id |  |  |
|  | company_id |  |  |
|  | client_company_id | Client Company ID |  |
|  | project_name |  |  |
|  | project_phase | 3:New,2:Modified,1:Operational |  |
|  | project_status | 0:Inactive,1:Active |  |
|  | sprint_week | How many weeks is one sprint? |  |
|  | current_sprint_order | Indicates the latest sprint |  |
|  | backlog_sprint_id | sprint_id indicating backlog |  |
|  | total_num_members | Total number of team members | select sum(num_members) from teams where id in select  team_id from project_team_map where project_id = ? |
|  | avg_velocity | Average velocity | select avg(avg_velocity) from teams where id in select  team_id from project_team_map where project_id = ? |
|  | avg_work_rate | Average utilization | select avg(avg_work_rate) from teams where id in select  team_id from project_team_map where project_id = ? |
|  | num_documents | Number of documents | select count(id) from documents where project_id = ? |
|  | avg_lead_time | Average lead time | select avg(velocity) from sprints where project_id = ? and status = complete |
|  | remain_work_hour | Average lead time x remaining backlog | avg_lead_time * num_backlog |
|  | expect_release_date | Estimated end date (based on average lead time x remaining backlog) | 現在の日時にremain_work_hour時間を足した日時 |
|  | num_backlog | Remaining backlog | select count(id) from tickets where sprint_id = backlog_id and status != 'close' |
|  | num_messages | Number of messages | select count(*) from messages where project_id = ? and reply_to_id = null |
|  | num_reactions | Number of reactions to messages | selct sum(num_reactions) from messages where project_id = ? |
|  | num_comments | Number of comments on messages | select count(*) from messages where project_id = ? and reply_to_id != null |
|  | num_mentions | Number of mentions | selct count(id) from mentions where project_id = ? |

| teams |  |  |  |
| --- | --- | --- | --- |
|  | id |  |  |
|  | team_name |  |  |
|  | company_id | Company ID |  |
|  | num_members | Number of Members | select count(developer_id) from developer_team_map where team_id = ? |
|  | avg_velocity | Average Velocity | select avg(velocity) from developer_project_sprint where developer_id in select  developer_id from developer_team_map where team_id = ? |
|  | avg_work_rate | Average Availability | select avg(work_rate) from developer_project_sprint where developer_id in select  developer_id from developer_team_map where team_id = ? |
|  | avg_lead_time | Average Lead Time | select avg(avg_lead_time) from developer_project_sprint where developer_id in select  developer_id from developer_team_map where team_id = ? |
|  | num_documents | Number of Documents | select count(*) from documents where developer_id IN select developer_id from developer_team_map where team_id = ? |

| project_team_map |  |
| --- | --- |
|  | project_id |
|  | team_id |

| sprints |  |  |  |
| --- | --- | --- | --- |
|  | id |  |  |
|  | name | Sprint Name |  |
|  | project_id | Project |  |
|  | order | Sequence | The first sprint in that project is 1, the next is 2, and so on, counting up. |
|  | start_date | Start Date |  |
|  | end_date | End Date |  |
|  | num_members | Number of Teams | select sum(num_members) from teams where id in select team_id from project_team_map where project_id = ? |
|  | num_ticket | Number of Tickets | select count(id) from tickets where sprint_id = ? |
|  | num_backlog | Number of backlogs | select num_backlog from projects where project_id = ? |
|  | total_work_hour | Total man-hours | select sum(expect_hours) from tickets where sprint_id = ? |
|  | close_work_hour | Completed man-hours | select sum(work_hours) from tickets where sprint_id = ? and status = complete |
|  | velocity | Velocity | select sum(difficulty) from tickets where sprint_id = ? and status = complete |
|  | avg_work_rate | Average Velocity | select avg(work_rate) from developer_project_sprint where sprint_id = ? |
|  | num_new_ticket | Number of new tickets | selct count(id) from tickets where sprint_id = ? and create_date がこのスプリントの日時の範囲内 |
|  | num_pull_request | Number of pull requests | select count(id) from pull_requests where sprint_id = ? |
|  | num_prs_merged | Number of merged PRs | select count(id) from pull_requests where sprint_id = ? and merge_datetime is not null |
|  | num_documents | Number of Documents | select count(id) from documents where sprint_id = ? |
|  | num_messages | Number of messages | selct count(id) from messages where project_id = ? and sprint_id = ? and reply_to_id = null |
|  | num_reactions | Reactions to messages | selct sum(num_reactions) from messages where project_id = ? and sprint_id = ? |
|  | num_comments | Number of comments on messages | selct count(id) from messages where project_id = ? and sprint_id = ? and reply_to_id != null |
|  | num_mentions | Number of mentions | selct count(id) from mentions where project_id = ? and sprint_id = ? |
|  | status  | Whether the sprint is completed or not (has passed the end date) |  |


| developers |  |  |  |
| --- | --- | --- | --- |
|  | id |  |  |
|  | user_id |  |  |
|  | avg_velocity | Average Velocity | select avg(velocity) from developer_project_sprint where developer_id = ? |
|  | avg_work_rate | Average Velocity | select avg(work_rate) from developer_project_sprint where developer_id = ? |
|  | num_documents | Number of Documents | select count(*) from documents where developer_id = ?  |
|  | avg_lead_time | Average Lead Time | select avg(avg_lead_time) from developer_project_sprint where developer_id = ? |
|  | avg_reviews | Number of Reviews | select count(id) from pull_requests where reviewer_id = ? |
|  | avg_review_hours | Average Review Time | select avg(review_hours) from developer_project where developer_id = ? |

| developer_mention_from |  |  |
| --- | --- | --- |
|  | developer_id | Developer ID |
|  | project_id | Project |
|  | mention_from | Who sent you the mentions? Developer ID |

| developer_mention_to |  |  |
| --- | --- | --- |
|  | developer_id | Developer ID |
|  | project_id | Project |
|  | mention_to | Who are you mentoring? Developer ID |

| tool_master |  |  |
| --- | --- | --- |
|  | id |  |
|  | tool_name |  |
|  | token_guide | Explains how to enter tokens |
|  | target_guide | Explains how to enter the target |
|  | payload_guide | Explains how to enter the payload |
|  | account_name_guide | Explain how to enter account_name |

| developer_tool_map |  | Mapping of account names and developers on tools such as Jira, Chatwork, Redmine, etc. |
| --- | --- | --- |
|  | developer_id |  |
|  | tool_id |  |
|  | account_name | Developer's account in that tool |

| project_tool_info |  | Mapping tools per project |
| --- | --- | --- |
|  | project_id |  |
|  | tool_id |  |
|  | token | Assume Token or password for API access |
|  | target | Assume Slack channel, Jira project, Git repository name, etc. |
|  | payload | Other data |

| developer_team_map |  |  |
| --- | --- | --- |
|  | developer_id |  |
|  | team_id |  |
|  | work_hour | Operating hours (weekly) on that team (usually 40 hours if you only belong to one team) |

| developer_project |  |  |  |
| --- | --- | --- | --- |
|  | developer_id |  |  |
|  | project_id |  |  |
|  | velocity | Number of tickets completed in a sprint * Ticket difficulty | select sum(difficulty) from tickets where devloper_id = ? and status = complete |
|  | total_expected_work_hours | Total man-hours expected | select sum(expect_hours) from tickets where devloper_id = ? |
|  | work_rate | Availability (total man-hours for completed tickets/total developer uptime) | select sum(work_hours) as project_work_hours from tickets where devloper_id = ? and status = complete; select work_hour AS team_work_hour from developer_team_map where developer_id = ? and team_id = ?;  work_rate = project_work_hours / team_work_hour * 100; |
|  | num_documents | Number of documents | select count(id) from documents where project_id = ? and developer_id = ? |
|  | num_messages | Number of messages | selct count(*) from messages where project_id = ? and developer_id = ? and reply_to_id = null |
|  | num_reactions | Number of reactions to messages | selct sum(num_reactions) from messages where project_id = ? and developer_id = ? |
|  | num_comments | Number of comments on messages | select scount(*) from messages where project_id = ? and developer_id = ? and reply_to_id != null |
|  | num_mentions | Number of mentions | selct count(id) from mentions where project_id = ? and developer_id = ? |
|  | avg_lead_time | Average lead time (hours) for completed tickets | select avg(work_hours) from tickets where devloper_id = ? and status = complete;  |
|  | num_new_ticket | Number of new tickets | selct count(id) from tickets where developer_id = ? and project_id = ? |
|  | num_pull_requests | Number of pull requests | select count(id) from pull_requests where project_id = ? and developer_id = ? |
|  | num_prs_merged | Number of merged pull requests | select count(id) from pull_requests where project_id = ? and developer_id = ? and merge_datetime is not null |
|  | num_reviews | Number of reviews | select count(id) from pull_requests where project_id = ? and reviewer_id = ? |
|  | review_hours | Review Time | select sum(merge_datetime - create_datetimeを時間単位) where id in select id from pull_requests where project_id = ? and reviewer_id = ? and merge_datetime is not null |
|  | start_date |  |  |
|  | end_date | Project Withdrawal Date |  |

| developer_project_sprint |  |  |  |
| --- | --- | --- | --- |
|  | developer_id |  |  |
|  | project_id |  |  |
|  | sprint_id |  |  |
|  | velocity | Number of tickets completed in a sprint * Ticket difficulty | select sum(difficulty) from tickets where devloper_id = ? and sprint_id = ? and status = complete |
|  | total_expected_work_hours | Total man-hours expected | select sum(expect_hours) from tickets where devloper_id = ? and sprint_id = ? |
|  | work_rate | Availability (total man-hours for completed tickets/total developer uptime) | select sum(work_hours) as sprint_work_hours from tickets where devloper_id = ? and sprint_id = ? and status = complete; select work_hour AS team_work_hour from developer_team_map where developer_id = ? and team_id = ?;  work_rate = sprint_work_hours / team_work_hour * 100; |
|  | num_documents | Number of documents | select count(id) from documents where sprint_id = ? and developer_id = ? |
|  | num_messages | Number of messages | select scount(*) from messages where project_id = ? and sprint_id = ? and developer_id = ? and reply_to_id = null |
|  | num_reactions | Number of reactions to messages | selct sum(num_reactions) from messages where project_id = ? and sprint_id = ? and developer_id = ? |
|  | num_comments | Number of comments on messages | select scount(*) from messages where project_id = ? and sprint_id = ? and developer_id = ? and reply_to_id != null |
|  | num_mentions | Number of mentions | selct count(id) from mentions where project_id = ? and sprint_id = ? and developer_id = ? |
|  | avg_lead_time | Average lead time (hours) for completed tickets | select avg(work_hours) from tickets where devloper_id = ? and sprint_id = ? and status = complete;  |
|  | num_new_ticket | Number of new tickets | selct count(id) from tickets where developer_id = ? and sprint_id = ? and create_date がこのスプリントの日時の範囲内 |
|  | num_pull_requests | Number of pull requests | select count(id) from pull_requests where sprint_id = ? and developer_id = ? |
|  | num_prs_merged | Number of merged pull requests | select count(id) from pull_requests where sprint_id = ? and developer_id = ? and merge_datetime is not null |
|  | num_reviews | Number reviewed | select count(id) from pull_requests where sprint_id = ? and reviewer_id = ? |
|  | review_hours | Time spent reviewing | select sum(merge_datetime - create_datetimeを時間単位) where id in select id from pull_requests where sprint_id = ? and reviewer_id = ? and merge_datetime is not null |

| skill_master |  |  |
| --- | --- | --- |
|  | id |  |
|  | project_id | If null, common to all projects |
|  | skill_name |  |
|  | creater_id | Creator's user_id, Admin if 0 |

| skill_developer |  |  |
| --- | --- | --- |
|  | developer_id |  |
|  | skill_id |  |
|  | months | Number of months the skill was used |

| domain_master |  |  |
| --- | --- | --- |
|  | id |  |
|  | project_id | If null, common to all projects |
|  | domain_name |  |
|  | creater_id | Creator's user_id, Admin if 0 |

| domain_developer |  |  |
| --- | --- | --- |
|  | developer_id |  |
|  | domain_id |  |
|  | months | Number of months experienced in that domain |

| developer_ career |  | Update as the project progresses, allowing users to enter their history prior to the introduction of Managetech. |
| --- | --- | --- |
|  | id |  |
|  | developer_id |  |
|  | start_month |  |
|  | end_month |  |
|  | project_id |  |
|  | role | Roles when participating (3:TL, 2:Manager, 1:Coder) |

| career_skill |  | Skills used/to be used in this career |
| --- | --- | --- |
|  | career_id |  |
|  | skill_id |  |

| career_domain |  | Domains that the developer was/will be responsible for in this career |
| --- | --- | --- |
|  | career_id |  |
|  | domain_id |  |


| document_developer_sprint |  |  |
| --- | --- | --- |
|  | developer_id |  |
|  | sprint_id |  |
|  | num_document | Number of documents |

| tickets |  |  |
| --- | --- | --- |
|  | id |  |
|  | developer_id | Contact Person |
|  | project_id |  |
|  | sprint_id |  |
|  | title |  |
|  | url | URL to view original ticket |
|  | status | Status |
|  | difficulty | Difficulty |
|  | start_date | Start Date |
|  | expect_hours | Estimated man-hours |
|  | work_hours | Man-hours Worked |
|  | end_date | Completion date |
|  | lead_time | end_date-start_date(hours) |
|  | create_date | Ticket creation date |
|  | ticket_uid | unique identifier |

| messages |  |  |
| --- | --- | --- |
|  | id |  |
|  | developer_id | Developer |
|  | project_id | Projects |
|  | sprint_id | Sprint |
|  | reply_to_id | Comment to which message. null if it is the parent message |
|  | channel | Channel name |
|  | url | URL to view the original message |
|  | contents |  |
|  | num_reactions | Number of reactions |
|  | message_uid | unique identifier |

| channels |  |  |
| --- | --- | --- |
|  | id |  |
|  | project_id | Projects |
|  | tool_id | Tool |
|  | name | Channel display name |
|  | channel_name | Identifier of the channel in the tool |
|  | channel_uid | unique identifier |

| mentions |  |  |
| --- | --- | --- |
|  | message_id | Message |
|  | project_id | Projects |
|  | sprint_id | Sprint |
|  | mention_to | Create record if mentions destination has developer_id |
|  | mention_uid | unique identifier |

| documents |  | Create this record when you discover a new page on the Github Wiki, Gitlab, Wiki or Redmine |
| --- | --- | --- |
|  | id |  |
|  | project_id | Projects |
|  | sprint_id | Sprint |
|  | developer_id | Author |
|  | title | Title |
|  | contents | Contents |
|  | document_uid | unique identifier |

| pull_requests |  |  |
| --- | --- | --- |
|  | id |  |
|  | project_id | Projects |
|  | sprint_id | Sprint |
|  | developer_id | Developer |
|  | url | URL to view the original pull request |
|  | title | Title |
|  | num_comments | Number of comments |
|  | contents | Content |
|  | create_datetime | Creation date/time |
|  | merge_datetime | Merge date/time (null if not completed) |
|  | pull_request_uid | unique identifier |

| batch_logs |  | Batch log of data acquisition |
| --- | --- | --- |
|  | id |  |
|  | company_id | Company ID |
|  | project_id | Project ID |
|  | module | Batch name |
|  | type | error, warning, info |
|  | content | Contents |
|  | start_datetime | Start date and time |
|  | end_datetime | End date and time |

| pull_request_reviewers |  |  |
| --- | --- | --- |
|  | pr_id | pull_request_id of the pull request |
|  | reviewer_id | Reviewer's developer_id |

| client_company_map |  |  |
| --- | --- | --- |
|  | company_id | Company ID |
|  | client_company_id | Client's Company ID |
|  | content | Contents |
|  | start_datetime | Start date and time |
|  | end_datetime | End date and time |

| pull_request_reviewers |  |  |
| --- | --- | --- |
|  | pr_id | pull_id of the pull request |
|  | reviewer_id | Reviewer's developer_id |

| client_company_map |  |  |
| --- | --- | --- |
|  | company_id | Company ID |
|  | client_company_id | Client's Company ID |
