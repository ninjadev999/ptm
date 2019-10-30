module Preferences
  class SettingsController < BaseController
    before_action :find_user, only:[:show, :edit]
    before_action :find_profile, only:[:show, :edit]

    def edit
    end

    def show
    end

    private

    def find_user
      @user = current_user
    end

    def find_profile
      @profile = find_user.profile
    end

  end
end