require_relative "boot"

require "rails/all"

require "dotenv"
Dotenv.load

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Managetech
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # We want to set up a custom logger which logs to STDOUT.
    # Docker expects your application to log to STDOUT/STDERR and to be ran
    # in the foreground.
    config.log_level = :debug
    config.log_tags = [:subdomain, :uuid]
    config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

    # Since we're using Redis for Sidekiq, we might as well use Redis to back
    # our cache store. This keeps our application stateless as well.
    config.cache_store = :redis_store, ENV["CACHE_URL"],
    { namespace: "managetech::cache" }

    # This also configures session_options for use below
    config.session_store :cache_store, key: "_interslice_session"

    # Required for all session management (regardless of session_store)
    config.middleware.use ActionDispatch::Cookies

    config.middleware.use config.session_store, config.session_options

    # If you've never dealt with background workers before, this is the Rails
    # way to use them through Active Job. We just need to tell it to use Sidekiq.
    config.active_job.queue_adapter = :sidekiq

    # Change the app to api app
    config.api_only = true

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Add lib folder to autoload paths
    config.autoload_paths += %W(#{config.root}/lib)
  end
end
