## Aggregate Timing and Batches

We are running the background tasks to synchronize the data of the database tables with the ones of the data server. 

We are using Redis and Sidekiq for the background tasks.

There are 2 background jobs running (DataSourceSyncJob and UpdateDeveloperCareer) and you can find the background jobs at `/managetech/app/sidekiq/`

DataSourceSyncJob pulls the data from the data server and updates the database tables, and it runs every 2 hours.

UpdateDeveloperCareer is updating the developer_careers table from the user input in the dashboard and it runs every month.