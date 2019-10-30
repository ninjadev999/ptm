# frozen_string_literal: true

module CurrentAccount
  class SubscriptionsController < BaseController
    before_action :find_subscription, except: [:create]

    def create
      subscription = Subscription.new(account: current_account, plan: Plan.first)
      if subscription.save
        redirect_to "/account/subscription", notice: "Your subscription was created."
      else
        redirect_to "/account/subscription", alert: "Your subscription couldn't be created: #{subscription.errors.full_messages.first}"
      end
    end

    def show
    end

    def update
    end

    def destroy
      if @subscription.destroy
        redirect_to "/account/subscription", notice: "Your subscription has been destroyed."
      else
        redirect_to "/account/subscription", alert: "Your subscription couldn't be destroyed."
      end
    end

  private

    def find_subscription
      @subscription = current_account.subscription
    end
  end
end
