# frozen_string_literal: true
module Guest
	module Interviews
		class AccountsController < BaseController
		  before_action :find_interview
		  before_action :find_account, except: [:index]

		  def index
		  	respond_to do |format|
		    	format.html do
		  			@accounts = AccountQuery.new(@interview).search
		  			if @accounts.count.zero? && @interview.invites.blank? # we don't want this step automatically skip when they have already walked through this step
							redirect_to interview_path(@interview), notice: 'Interview has been created successfully!'
		  			end
		    	end
		    	format.js do
						@accounts = AccountQuery.new(@interview, filter_params).search.page(1).per(5)
		    	end
		    end
		  end

		  def invite
		  	invite = Invite.where(interview: @interview, account: @account).first 
		  	invite ||= Invite.new(interview: @interview, name: @account.name, email: @account.admin.email, account: @account)

		  	if invite.invited!
		  		redirect_to params[:redirect_url], notice: "#{@account.name} has been invited!"
		  	else
		  		redirect_to params[:redirect_url], notice: invite.errors.full_messages.join(',')
		  	end
		  end

		  private

		    def find_interview
		      @interview = Interview.find(params[:interview_id])
		      # TODO: authorization
		    end

		    def find_account
		      @account = Account.find(params[:account_id])
		    end

	  		def filter_params
					params.require(:filter).permit(topic_list: [], promotion_list: [], expertise_list: [])
				end

		end
	end
end