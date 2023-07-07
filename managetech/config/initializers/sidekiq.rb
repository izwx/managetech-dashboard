sidekiq_config = {
  url: ENV["JOB_WORKER_URL"] || "redis://localhost:6379/1",
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }, # we must trust Heroku and AWS here
}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

schedule_file = "config/schedule.yml"
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
