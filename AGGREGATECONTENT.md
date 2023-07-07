## Aggregate Content and User Roles

We pull the data from the data server and aggregate the contents. And we defined 5 user roles and they view different aggregate contents depending on their permissions.

### User Roles

- Management User(Manager)
- Client
- Project Manager
- Developer
- Managetech Administrator

### Aggregate Content

**Project List (For Managers)**
- Project Name(s)
- Name of team(s) in charge (if more than one)
- Current sprint name (sprint number if not specified)
- Average Velocity
- Average Velocity
- Number of backlogs
- Progress rate
- Number of delayed tickets
- Average Lead Time
- Average lead time x remaining backlog
- Average number of messages
- Deadline
- Estimated End Date

**Team List (For Managers)**

- Team Name
- Number of Teams
- Average Velocity
- Average Velocity
- Number of Delayed Tickets
- Average Lead Time
- Average number of messages
- Low utilization

**Project(For Clients)**

- Project Name
- Number of Backlogs Remaining
- Progress rate
- Number of delayed tickets
- Average lead time
- Average Lead Time x Remaining Backlog
- Backlog Transition Graph
- Velocity Transition Graph
- Deadline
- Expected End Date
- Most recently completed tasks (3 in order of man-hours)
- Tasks currently being worked on (3 in order of man-hours)

**Project (For Project Managers and Developers)**

- Project Name
- Name of team(s) in charge
- Total Number of Team Members
- Average Velocity
- Average Velocity
- Number of Documents
- Current sprint name (sprint number if not specified)
- Progress rate
- Average lead time
- Average lead time x remaining backlog
- Deadline
- Estimated End Date
- Average Lead Time Transition Graph
- Backlog Transition Graph
- Velocity Transition Graph
- New Ticket Transition Graph
- Number of Pull Requests Transition Graph
- Number of Merged PRs Transition Graph
- Message Count Transition Graph
- List of tickets open for more than 10 days
- List of tickets delayed more than 5 days
- List of developers whose utilization rate has dropped
- List of tickets with many PR comments
- List of developers with many PR comments
- List of tickets with long review times

**Sprint(For Project Managers and Developers)**

- Sprint name (sprint number if not specified)
- Number of tickets
- Total number of tickets (also show the difference from the previous sprint)
- Total man-hours/team (also shows difference from previous sprint)
- Completed man-hours (also shows difference from previous sprint)
- Velocity (also shows difference from previous sprint)
- Average utilization (also shows difference from previous sprint)
- Number of new tickets (also shows difference from previous sprint)
- Number of pull requests (also shows difference from previous sprint)
- Number of merged PRs (also shows difference from previous sprint)
- Number of messages (also shows difference from previous sprint)
- Backlog transition graph
- Velocity transition graph
- New Ticket Transition Graph
- Number of Pull Requests Transition Graph
- Merged PRs Transition Graph
- Message Count Transition Graph
- List of tickets not completed
- Team(For Project Managers)
- Team Name
- Number of team members
- Name of active project
- Average Velocity
- Average Velocity
- Number of Documents
- Backlog Transition Graph
- Velocity Transition Graph
- Average Lead Time
- Average Lead Time Transition Graph
- Backlog Transition Graph
- Velocity Transition Graph
- New Ticket Transition Graph
- Number of Pull Requests Transition Graph
- Number of Merged PRs Transition Graph
- Message Count Transition Graph
- Member List
- Star Chart
- List of developers with most PR comments
- Top 5 PRs
- Number of messages TOP5
- Average lead time TOP5

**Developer(For Project Managers and Developers)**

- Developer(s) Name(s)
- Name of team(s) in charge
- Average Velocity
- Average Velocity
- Number of Documents
- Average Lead Time
- Backlog Transition Graph
- Backlog Transition Graph
- Velocity Transition Graph
- New Ticket Transition Graph
- Number of Pull Requests Transition Graph
- Number of Merged PRs Transition Graph
- Message Count Transition Graph
- Skill List
- Domain List
- Number of Reviews
- Average Review Time

**System Setting(For Managetech Admins)**

- List of Skills and Domains
- Link to Skill/Domain Settings Screen
- Company List
- Link to company management screen
- Database Settings Display
- Link to Database Settings screen
- Tool Master Display
- Link to tool master settings screen
- Tool Master Settings Screen
- Skill and Domain Settings Screen
- Database Settings Screen
- Career Summary Edit Screen

**Report Screen(For Managetech Admins)**

- Current Number of Companies
- Number of Companies Graph
- Current Projects
- Number of Projects Graph
- Current Developers
- Number of Developers Graph

**Managetech Management(For Managetech Admins)**

- Skill and Domain Settings Screen
- Tool Settings Screen