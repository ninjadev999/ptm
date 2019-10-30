# frozen_string_literal: true

Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.paths << Rails.root.join("vendor")
Rails.application.config.assets.precompile += %w[theme.css theme.js checkout.js checkout_addon_seats.js cocoon.js]
