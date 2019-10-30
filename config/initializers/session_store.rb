# frozen_string_literal: true

if Rails.env.production?
  Rails.application.config.session_store :cookie_store, key: "_ptm_session" # , domain: ".passthemicrophone.com"
else
  Rails.application.config.session_store :cookie_store, key: "_ptm_session"
end
