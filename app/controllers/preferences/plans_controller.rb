module Preferences
	class PlansController < BaseController
		before_action :load_plan, only: [:update, :update_host_plan]
		skip_before_action :trial_expire

		def show;	end

		def update
			if current_user.guest_subscription && !current_user.guest_subscription.destroy
				return redirect_to preferences_plans_path, notice: current_user.guest_subscription.errors.full_messages.join(', ')
			end

			if @plan.nil?
				redirect_to preferences_plans_path, notice: 'Your subscription updated!'
			else
				guest_subscription = Subscription.new(user: current_user, plan: @plan)
		    if guest_subscription.save
	        redirect_to preferences_plans_path, notice: 'Your subscription updated!'
	      else
	        redirect_to preferences_plans_path, alert: guest_subscription.errors.full_messages.join('; ')
	      end
	    end
		end

		def host_plan
		end

		def update_host_plan
			if current_user.host_subscription && !current_user.host_subscription.destroy
				return redirect_to host_plan_preferences_plans_path, notice: current_user.host_subscription.errors.full_messages.join(', ')
			end

			if @plan.nil?
				redirect_to host_plan_preferences_plans_path, notice: 'Your subscription updated!'
			else
				host_subscription = Subscription.new(user: current_user, plan: @plan)
				if host_subscription.save
					redirect_to host_plan_preferences_plans_path, notice: 'Your subscription updated!'
				else
					redirect_to host_plan_preferences_plans_path, alert: host_subscription.errors.full_messages.join('; ')
				end
			end
		end

		private

			def load_plan
				@plan = Plan.find_by_id(params[:plan])
			end

	end
end