module Guest
  class AccountSetupsController < Guest::BaseController
    skip_before_action :authenticate_user!, only: [:set_password, :choose_plan, :select_plan]
    skip_before_action :account_setup

    before_action :load_plan, only: [:checkout, :purchase]
    layout 'account'

    # From invite flow : set_password -> choose_plan -> select_plan -> settings -> checkout -> purchase
    # From landing page: choose_plan -> ...

    # TODO: these should go to each controller
    def set_password
      load_user_from_invite
      render layout: 'devise'
    end

    def choose_plan
      if current_user.present? and current_user.host? and (current_user.bundle_itv_purchased > 0 or current_user.host_subscription.present?)
        redirect_to settings_account_setups_path
      end
    end

    def select_plan
      session[:plan] = params[:plan]
      if user_signed_in? # From invite
        redirect_to settings_account_setups_path
      else
        redirect_to new_user_registration_path(guest: true)
      end
    end

    def settings
      @user = current_user
      if request.put?
        if @user.update(user_params)
          redirect_to preview_account_setups_path
        else
          flash.now[:error] = @user.errors.full_messages.join('; ')
          render template: 'guest/account_setups/settings'
        end
      end
    end

    def preview
      @user = current_user
    end

    def checkout
      current_user.update(guest: true)
      current_user.assign_invites
      set_user_role(:guest)
      return redirect_to after_sign_in_path_for(current_user) if session[:plan].nil?
    end

    def purchase
      credit_card ||= set_card_from_params
      @stripe_token = params[:stripeToken]
      if @stripe_token.present?
        credit_card = current_user.credit_cards.new(token: @stripe_token)
        redirect_to(checkout_account_setups_path, alert: credit_card.errors.full_messages.join('; ')) unless credit_card.save
      end

      subscription = Subscription.new(user: current_user, plan: @plan)
      if subscription.save
        redirect_to interviews_path, notice: 'Your subscription added!'
      else
        redirect_to checkout_account_setups_path, alert: subscription.errors.full_messages.join('; ')
      end
    end

    private

      def load_plan
        @plan = Plan.find_by(id: session[:plan]) || Plan.basic_plan
      end

      def set_card_from_params
        if credit_card_id
          current_user.credit_cards.find_by(id: credit_card_id)
        end
      end

      def credit_card_id
        params.dig(:credit_card, :id)
      end

      def load_user_from_invite
        @user = User.new
        invite = Invite.find_by_code(session[:invite_code])
        if invite.present?
          first_name, last_name = invite.name.split(' ').map(&:strip)
          @user.email = invite.email
          @user.first_name = first_name
          @user.last_name = last_name
        else
          redirect_to :root_path, error: 'Invite not found!'
        end
      end

      def user_params
        params.require(:user).permit(:email, :first_name, :last_name, :current_password, :password, :password_confirmation, :username,
          profile_attributes: [:id, :bio, :primary_industry, :photo, :audio_recording], expertise_list: [], promotion_list: [], topic_list: [])
      end
  end
end