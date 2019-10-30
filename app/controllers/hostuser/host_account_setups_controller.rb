module Hostuser
  class HostAccountSetupsController < Hostuser::BaseController
    include ActionView::Helpers::NumberHelper
    skip_before_action :authenticate_user!, only: [:set_password, :choose_plan, :select_plan, :buy_interview, :select_bundle]
    layout 'account'

    before_action :load_plan, only: [:checkout, :purchase]
    before_action :handle_token, only: [:purchase_bundle]
    before_action :set_vars, only: [:purchase_bundle]
    skip_before_action :trial_expire, raise: false

    # TODO: these should go to each controller
    def set_password
      load_user_from_invite
      render layout: 'devise'
    end

    def choose_plan

    end

    def select_plan
      session[:host_plan] = params[:plan]
      if user_signed_in? # From invite
        redirect_to checkout_host_account_setups_path
      else
        redirect_to new_user_registration_path(host: true)
      end
    end

    def checkout
      current_user.update(host: true)
      set_user_role(:host)
      return redirect_to after_sign_in_path_for(current_user) if session[:host_plan].nil?
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
        redirect_to accounts_path, notice: 'Your subscription added!'
      else
        redirect_to checkout_account_setups_path, alert: subscription.errors.full_messages.join('; ')
      end
    end

    def buy_interview
      @bundles = Bundle.active.count_descending
    end

    def select_bundle
      session[:host_bundle] = params[:bundle_id]
      if user_signed_in?
        redirect_to checkout_interview_host_account_setups_path
      else
        redirect_to new_user_registration_path(host: true)
      end
    end

    def checkout_interview
      current_user.update(host: true)
      set_user_role(:host)
      @bundle = Bundle.find(session[:host_bundle]) if session[:host_bundle].present?
      @bundles = Bundle.active.count_descending
      @order_total = @bundle.price_in_cents
      @order_total_in_dollars = @order_total / 100.0
      @purchase_url = purchase_bundle_host_account_setups_path params: {bundle_id: session[:host_bundle]}

      return redirect_to after_sign_in_path_for(current_user) if session[:host_bundle].nil?
    end

    def purchase_bundle
      @credit_card ||= set_card_from_params
      # @bundle = Bundle.find(session[:host_bundle]) if session[:host_bundle].present?
      @stripe_charger = StripeCharger.new(current_user, @credit_card, @bundle)

      @stripe_charger.charge!

      if @stripe_charger.success?
        @interview.payment_complete! if !@interview.nil?
        current_user.add_bundle!(@bundle)
        amount_str = number_to_currency(@stripe_charger.order_total_in_dollars)
        redirect_to selector_interviews_path(posting: session[:new_interview_posting]), notice: "Your card has been authorized and charged #{amount_str}."
      else
        redirect_to accounts_path, alert: @stripe_charger.declined_explanation
      end
    end

    private

    def load_plan
      @plan = Plan.find_by(id: session[:host_plan]) || Plan.host_monthly_plan
    end

    def set_card_from_params
      if credit_card_id
        current_user.credit_cards.find_by(id: credit_card_id)
      end
    end

    def credit_card_id
      params.dig(:credit_card, :id)
    end

    def handle_token
      @stripe_token = params[:stripeToken]
      if !@stripe_token.blank?
        @credit_card = current_user.credit_cards.new(token: @stripe_token)
        if @credit_card.save
          # do nothing
        else
          redirect_to construct_checkout_path, alert: @credit_card.errors.full_messages.join('; ')
        end
      end
    end

    def set_vars
      @bundle = Bundle.find(params[:bundle_id])
    end

    def load_user_from_invite
      @user = User.new
      invite = PodcastInvite.find_by_code(session[:invite_code])
      if invite.present?
        first_name, last_name = invite.name.split(' ').map(&:strip)
        @user.email = invite.email
        @user.first_name = first_name
        @user.last_name = last_name
      else
        redirect_to :root_path, error: 'Invite not found!'
      end
    end

  end
end