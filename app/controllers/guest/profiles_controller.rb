# frozen_string_literal: true

module Guest
  class ProfilesController < Guest::BaseController
    before_action :find_user, only:[:show]
    before_action :find_profile, only:[:show]
    skip_before_action :authenticate_user!, only: [:show_public_profile]
    skip_before_action :find_user, only: [:show_public_profile]
    skip_before_action :find_profile, only: [:show_public_profile]
    skip_before_action :account_setup, only: [:show_public_profile]

    include SocialSitesHelper
    include PublicSitesHelper

    def show
      redirect_to settings_account_setups_path if @profile.nil?
    end

    def show_public_profile
      @profile = Profile.where(id: params[:id]).first
      @user = @profile.present? ? @profile.user : nil
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