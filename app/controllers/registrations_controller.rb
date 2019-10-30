class RegistrationsController < Devise::RegistrationsController
	# POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.host? && params[:user][:from_invite].present? && params[:code].present?
        podcast_invite = PodcastInvite.find_by!(code: params[:code])
        podcast_invite.update(user_id: resource.id) if podcast_invite.present?
        podcast_invite.set_account_user if podcast_invite.present?
      end
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length

      # Custom code
      if resource.guest? && params[:user][:from_invite].present?
      	if resource.errors.details[:email].present?
      		flash[:error] = "Your email #{resource.email} is already registered. Try sign in instead."
	      	return redirect_to new_user_session_path
      	else
      		flash[:error] = resource.errors.full_messages.join(', ')
	      	return redirect_to set_password_account_setups_path
        end
      elsif resource.host? && params[:user][:from_invite].present?
        if resource.errors.details[:email].present?
          flash[:error] = "Your email #{resource.email} is already registered. Try sign in instead."
          return redirect_to new_user_session_path
        else
          flash[:error] = resource.errors.full_messages.join(', ')
          return redirect_to set_password_host_account_setups_path
        end
      end
      respond_with resource
    end
  end

  private

    def after_sign_up_path_for(resource)
      if host?
        if session[:host_bundle].present?
          checkout_interview_host_account_setups_path params: {bundle_id: session[:host_bundle]} 
        elsif session[:host_plan].blank? # From set password form
          resource.accounts.exists? ? accounts_path : new_account_path
        else # From user sign up form
          checkout_host_account_setups_path
        end
      else
        if session[:plan].blank? # From set password form
          choose_plan_account_setups_path
        else # From user sign up form
          settings_account_setups_path
        end
      end
    end

end
