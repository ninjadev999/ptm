# frozen_string_literal: true

require_relative "boot"

require "rails/all"
require 'elasticsearch/rails/instrumentation'
# Require the gems listed in Gemfile, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ptm
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.autoload_paths << "#{Rails.root}/lib"
    config.autoload_paths << "#{Rails.root}/app/models/interviews"
    config.uuid_characters = "ABCDEFGHJKLMNPQRTUVWXYZ3456789"

    def warehouse_address
      @warehouse_address ||= Address.find_or_create_by(
        name: "PassTheMicrophone.com LLC",
        street1: "55 Bahama Ave",
        city: "Key Largo",
        state: "FL",
        zip: "33037",
        country: "US",
        phone: "310-808-5243"
      )
    end
    config.active_job.queue_adapter = :sidekiq

    def twilio_callback_host
      ENV['DOMAIN']
    end

    def stripe
      @stripe ||= OpenStruct.new(publishable_key: ENV["STRIPE_PUBLISHABLE_KEY"], secret_key: ENV["STRIPE_SECRET_KEY"])
    end

    def twilio_client
      @twilio_client ||= begin
        account_sid = ENV["TWILIO_ACCOUNT_SID"]
        auth_token = ENV["TWILIO_AUTH_TOKEN"]
        Twilio::REST::Client.new account_sid, auth_token
      end
    end

    if Rails.env.production?
      require "#{Rails.root}/lib/cloudflare"
      config.middleware.insert_before(0, Rack::CloudFlareMiddleware)
    end
  end
end
