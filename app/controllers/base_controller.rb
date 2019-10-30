# frozen_string_literal: true

class BaseController < ApplicationController
  layout "app"
  require_dependency "dependencies/account_dependency"
  require_dependency "dependencies/account_admin_dependency"
  before_action :trial_expire

  def redirect_if_no_accounts
    redirect_to new_account_path and return if current_user.accounts.count == 0
  end

  def alert_free_interview
    if current_user&.free_interview_eligible?
      notice = "You have #{view_context.pluralize(NUM_FREE_INTERVIEWS - current_user.free_interviews_count, 'free interview')}. Create interview #{view_context.link_to('here', new_interview_path(needs_hardware: false))}.".html_safe
      flash.now[:notice] = notice
    end
  end

  def trial_expire
    return unless user_signed_in?
    # In the case no plan, check valid expiration for 1 month
    if host? && !(current_user.host_subscription.present? or current_user.bundle_itv_remaining > 0)
      expiration_day = (Time.now.to_i - current_user.created_at.to_i) / 86400
      if expiration_day >= 30
        flash[:notice] = 'Your free trial expired. You need to purchase subscription or interview packs to continue.'
        redirect_to choose_plan_host_account_setups_path
      end
    end
  end
end
