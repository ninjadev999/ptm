# frozen_string_literal: true

class PreferencesController < BaseController
  before_action :set_user

  def show
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Profile has been update!'
      redirect_to preferences_settings_path
    else
      flash.now[:error] = @user.errors.full_messages.join('; ')
      render template: 'preferences/settings/show'
    end
  end

  def update_password
    unless @user.valid_password?(user_params[:current_password])
      @user.errors.add(:current_password, "is not your current password.")
      return render :show
    end
    if @user.update_attributes(user_params.except(:current_password))
      if user_params[:password].present?
        flash[:notice] = "Password changed. Please login again."
      else
        flash[:notice] = "Successfully updated your profile."
      end
      return redirect_to "/preferences"
    end
    render :show
  end

private

  # for form helpers
  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :current_password, :password, :password_confirmation,
      profile_attributes: [:id, :bio, :primary_industry, :photo, :audio_recording], expertise_list: [], promotion_list: [], topic_list: [])
  end
end
