# frozen_string_literal: true

require "sidekiq"

Sidekiq.configure_server do |config|
  config.redis = { size: 17 }
end
