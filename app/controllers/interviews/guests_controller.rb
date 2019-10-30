# frozen_string_literal: true
module Interviews
	class GuestsController < BaseController

	  before_action :find_interview
	  before_action :find_guest, except: [:index]

	  def index
	  	respond_to do |format|
	    	format.html do
	  			@guests = GuestQuery.new(@interview).search
	  			if @guests.count.zero?
						redirect_to interview_path(@interview), notice: 'Interview has been created successfully!'
	  			end
	    	end
	    	format.js do
					@guests = GuestQuery.new(@interview, filter_params).search.page(1).per(5)
	    	end
	    end
	  end

	  def invite
	  	invite = Invite.new(interview: @interview, name: @guest.full_name, email: @guest.email, guest: @guest, status: :invited)
	  	if invite.save
	  		redirect_to params[:redirect_url], notice: "#{@guest.full_name} has been invited!"
	  	else
	  		redirect_to params[:redirect_url], notice: invite.errors.full_messages.join(',')
	  	end
	  end

	  private

	    def find_interview
	      @interview = Interview.find(params[:interview_id])
	      # TODO: authorization
	    end

	    def find_guest
	      @guest = User.guest.find(params[:guest_id])
	    end

  		def filter_params
				params.require(:filter).permit(topic_list: [], promotion_list: [], expertise_list: [])
			end

	end
end