# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  require_dependency "dependencies/user_role_dependency"
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :guest, :host]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_dashboard_path
    else
      if session[:redirect_to_zoho].present?
        session[:redirect_to_zoho] = nil
        zs = ZohoService.new(resource)
        return zs.redirect_url
      end
      stored_location_for(resource) || interviews_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  def track_back_path
    session[:back_path] = request.path
  end

  helper_method :staging?
  def staging?
    ENV['STAGING'] == 'true'
  end

  private

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || interviews_path)
    end

end
