# frozen_string_literal: true

class ZohoController < BaseController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def index
    case params[:opertion]
    when 'signup'
      # We would rather not impilement Signup because we don't want people signing up via Zoho
      #  and creating accounts. The only people using our Zoho helpdesk should be users that
      #  already have accounts with us. So for now, just redidirect them to our Sign up page
      return redirect_to new_user_registration_path
    else
      if !user_signed_in?
        session[:redirect_to_zoho] = true
        return redirect_to new_user_session_path
      else
        zs = ZohoService.new(current_user)
        #puts "\nZoho Redirect to: #{zs.redirect_url}\n"
        return redirect_to(zs.redirect_url)
      end
    end
  end

end
