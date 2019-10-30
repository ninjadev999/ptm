# frozen_string_literal: true

module Guest
	class InterviewsController < Guest::BaseController
		before_action :find_interview, only: [:apply, :show, :show_account, :see_detail]
    before_action :track_back_path, only: [:show]
    skip_before_action :find_interview, only: [:new]

		def index
			interviews = current_user.guest_interviews
			@interviews = interviews.upcoming_for_guest
			@past_interviews = interviews.past
			@active_applicants = current_user.guest_applicants
			@solicited_interviews = current_user.guest_solicited_interviews
		end

		def new
			solicited = params[:solicited] == 'true'
			@interview ||= Interview.new(posting: params[:posting], type: solicited ? 'SolicitedInterview' : 'HostInterview')
			@interview.needs_hardware = ActiveModel::Type::Boolean.new.cast(params[:needs_hardware])
		end

		def show
      if @interview.posting?
        @guests = GuestQuery.new(@interview).search.page(1).per(5)
      elsif @interview.guest_solicited?
        @accounts = AccountQuery.new(@interview).search.page(1).per(5)
      end

      if @interview.ended?
        @audio_recordings = @interview.recordings.select { |r| r.twilio_data["Container"] == "mka" }
        @video_recordings = @interview.recordings.select { |r| r.twilio_data["Container"] == "mkv" }
        @guests ||= GuestQuery.new(@interview).search.page(1).per(5)
      end

      flash.now[:notice] = 'Interview has been updated successfully.' if params[:updated].present?

      respond_to do |f|
        f.html
      end
		end

		def see_detail
		end

		def search
	  	respond_to do |format|
	    	format.html do
					search_interview
	    	end
	    	format.js do
					search_interview
	    	end
	    end
		end

	  def apply
	  	applicant = Invite.new(interview: @interview, name: current_user.full_name, email: current_user.email, guest: current_user, status: :applied)
	  	if applicant.save
				InterviewsMailer.apply(applicant).deliver_later
	  		redirect_to search_interviews_path, notice: "You have applied to interview - #{@interview.name}!"
	  	else
	  		redirect_to search_interviews_path, notice: "Can't apply to interview - #{@interview.name}"
	  	end
		end

		def show_account
			@account = @interview.account
		end

	  private

    def find_interview
      @interview = Interview.find(params[:interview_id] || params[:id])
    end

    def filter_params
      params.require(:filter).permit(topic_list: [], promotion_list: [], expertise_list: [])
    end

		def search_interview
			if params[:filter].present?
				@interviews = InterviewQuery.new(current_user, nil, filter_params).search #.page(params[:page]).per(5)
			else
				@interviews = InterviewQuery.new(current_user).search #.page(params[:page]).per(5)
			end
		end

	end
end