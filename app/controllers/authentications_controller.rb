class AuthenticationsController < Devise::OmniauthCallbacksController
  def linkedin
    omniauth
  end

  def facebook
    omniauth
  end

  private

    def omniauth
      auth = request.env['omniauth.auth']
      user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.find_by_email(auth['info']['email'])

      guest_signup = request.env['omniauth.params']['guest'] == 'true'
      host_signup = request.env['omniauth.params']['guest'] == 'false'

      # if user is already existing, make sure they signed up for right type(they can sign up for both type)
      if user
        if host_signup
          set_user_role(:host)
          if user.host?
            return redirect_to new_user_session_path, notice: 'You already have Host account. Try sign in!'
          else
            user.update(host: true)
          end
        elsif guest_signup
          set_user_role(:guest)
          if user.guest?
            return redirect_to new_user_session_path, notice: 'You already have Guest account. Try sign in!'
          else
            user.update(guest: true)
          end
        else
          # then it's login action
        end
      else
        # Need to make this separate because user need to be one of host vs guest on creation
        user = User.create_with_omniauth(auth, guest_signup)
      end

      sign_in(user, scope: :user)
      if guest_signup || host_signup
        redirect_to after_sign_up_path_for(user), :notice => "Signed up for #{guest_signup ? 'Guest' : 'Host'} account!"
      else
        redirect_to after_sign_in_path_for(user), :notice => 'Signed in!'
      end
    end

    def after_sign_up_path_for(resource)
      if host?
        new_account_path
      else
        settings_account_setups_path
      end
    end
end