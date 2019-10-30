# frozen_string_literal: true

module Guest
  class BaseController < ::ApplicationController
    layout "guest"

    before_action :account_setup

    def account_setup
    	flash.now[:notice] = "Complete your profile #{view_context.link_to('here', preferences_settings_path)}.".html_safe if current_user.profile.blank?
    end
  end
end
