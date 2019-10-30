# frozen_string_literal: true


Rails.application.configure do
  config.active_storage.service = :amazon
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.action_cable.url = "ws://#{ENV['DOMAIN']}/cable"
  config.assets.compile = false
  config.force_ssl = false
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.cache_store = :redis_cache_store, { url: ENV["REDIS_URL"] }
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false
  # config.action_mailer.delivery_method = :mailgun
  # config.action_mailer.mailgun_settings = {
  #     api_key: ENV["MAILGUN_API_KEY"],
  #     domain: "passthemicrophone.com"
  # }
  ActionMailer::Base.smtp_settings = {
  :port           => 587,
  :address        => "smtp.mailgun.org",
  :domain         => "https://api.mailgun.net/v3/mg.passthemicrophone.com",
  :user_name      => "postmaster@mg.passthemicrophone.com",
  :password       => "ab5b3775d41b8371bd8e51c337c828cb-1053eade-dc99caed",
  :authentication => :plain,
  }
  config.action_mailer.default_url_options = { host: ENV['DOMAIN'], protocol: "https" }
end
