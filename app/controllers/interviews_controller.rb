# frozen_string_literal: true

class InterviewsController < BaseController
  before_action :redirect_if_no_accounts, except: [:live, :prep, :waiting_room, :create_track_sid], if: :host?
  before_action :alert_free_interview, only: :index, if: :host?
  before_action :find_interview, only: [:show, :edit, :update, :destroy, :new_invite, :create_invite, :gateway, :launch, :live_room_html, :apply, :see_detail]
  before_action :find_interview_by_code, only: [:live, :prep, :audiovisual_check]
  before_action :track_back_path, only: [:show, :search]
  skip_before_action :verify_authenticity_token

  def index
    @account = current_account.decorate
    @interviews = @account.interviews.upcoming
    @past_interviews = @account.interviews.past
  end

  def new
    # if params[:needs_hardware].blank?
    # redirect_to selector_interviews_path
      # return
    # end
    setup_for_new
  end

  def create
    @interview = if host?
      current_account.host_interviews.new(interview_params)
    else
      current_user.guest_solicited_interviews.new(interview_params)
    end
    if @interview.save
      return_url = interview_accounts_path(@interview) if @interview.guest_solicited?
      return_url ||= @interview.posting? ? interview_guests_path(@interview) : new_invite_path(interview_id: @interview)
      redirect_to return_url
    else
      flash.now[:alert] = "There was a problem with the options you selected for your interview: #{@interview.errors.full_messages.join('; ')}"
      render :new and return
    end
  end

  def edit
    if @interview.ended?
      # redirect_to "/interviews/#{@interview.to_param}", notice: "Interview has completed."
    end
  end

  def gateway
  end

  def audiovisual_check
  end

  def waiting_room
    @interview = Interview.find_by_code(params[:id]).decorate
    if @interview.live?
      return redirect_to live_interview_path(id: @interview.code), alert: "Your interview is LIVE. Click 'Join Room' to join your host."
    end
    @prep = (params[:prep] == 'true') || @interview.prep?
    ready_invite
  end

  def live_room_html
    render layout: nil
  end

  def prep
    session["#{@interview.code}_identity_id"] = current_user&.id || SecureRandom.hex
    begin
      Rails.application.twilio_client.video.rooms(@interview.prep_code).fetch
    rescue
      Rails.application.twilio_client.video.rooms.create(@interview.prep_room_params)
    end
    @my_room = host_of?(@interview)
    guest_name = params[:name] ? params[:name] : "guest"
    identity = current_user ? current_user.email : guest_name
    @access_token = TwilioCapability.generate_for_video_room(@interview.prep_code, identity)

    if @my_room
      @interview.state = 'prep'
      @interview.save(validate: false)
    end

    render json: { access_token: @access_token, room_name: @interview.prep_code, interview: JSON::parse(@interview.to_json)}
  end

  def launch
    # this can become live! but currently there's an issue w/ Topic validation
    @interview.state = 'live'
    @interview.save(validate: false)
    redirect_to live_interview_path(id: @interview.code), notice: "Your interview is ready. Click 'Join Room' to go LIVE!"
  end

  def live
    if @interview.prep?
      if host_of?(@interview)
        return redirect_to gateway_interview_path(@interview), notice: "Please confirm your audiovisual settings before going live."
      else
        ready_invite
        return redirect_to waiting_room_path(id: @interview.code, prep: true), alert: "This is a pre-interview prep room with your host to test your audiovisual settings."
      end
    elsif !@interview.live?
      if host_of?(@interview)
        return redirect_to gateway_interview_path(@interview), notice: "Please confirm your audiovisual settings before going live."
      else
        ready_invite
        return redirect_to audiovisual_check_path(id: @interview.code), alert: "The host has not yet started the interview."
      end
    end
    session["#{@interview.code}_identity_id"] = current_user&.id || SecureRandom.hex
    begin
      Rails.application.twilio_client.video.rooms(@interview.code).fetch
    rescue
      Rails.application.twilio_client.video.rooms.create(@interview.room_params)
    end
    @my_room = host_of?(@interview)
    guest_name = params[:name] ? params[:name] : "guest"
    identity = current_user ? current_user.email : guest_name
    @access_token = TwilioCapability.generate_for_video_room(@interview.code, identity)
  end

  def create_track_sid
    @interview = Interview.find_by_code(params[:id])
    track_type = (params[:track_type] == 'video') ? 1 : 0
    track_sid = TrackSid.create!(interview_id: @interview.id,
                                 user_id: current_user.id,
                                 track_type: track_type,
                                 track_sid: params[:track_sid])
    render json: track_sid.to_json
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

  def selector
    @posting = params[:posting]

    if @posting == 'true'
      if current_user.posting_available?
        return redirect_to new_interview_path(needs_hardware: false, posting: @posting)
      else
        flash.now[:notice] = 'You need to purchase interview bundle to invite PTM guests'
      end
    else
      if current_user.single_itv_available?
        return redirect_to new_interview_path(needs_hardware: false)
      end
    end
    session[:new_interview_posting] = @posting
    @bundles = Bundle.active.count_descending
    flash[:notice]  = 'You already have used tree free interviews. You need to purchase to create new invites.'
    redirect_to choose_plan_host_account_setups_path
  end

  def update
    if @interview.update_attributes(interview_params)
      respond_to do |f|
        f.html do
          flash[:notice] = 'Interview updated' if @interview.posting?
          return_url = (@interview.posting? || @interview.guest_solicited?) ? interview_path(@interview) : new_invite_path(interview_id: @interview)
          redirect_to return_url
        end
        f.js { render js: "window.location.reload()" }
        f.json { render json: {success: true} }
      end
    else
      render :edit
    end
  end

  def destroy
    if @interview.destroy
      redirect_to interviews_path, notice: "Successfully removed interview."
    else
      redirect_to interviews_path, alert: "Couldn't destroy interview."
    end
  end

  # Solicited interviews
  def search
    respond_to do |format|
      format.html do
        @interviews = InterviewQuery.new(current_user, current_account).search
        @account = current_account.decorate
        @active_applicants = @account.applicants
        @invites = @account.invites
      end
      format.js do
        @interviews = InterviewQuery.new(current_user, current_account, filter_params).search
      end
    end

  end

  def apply
    applicant = Invite.new(interview: @interview, name: current_account.name, email: current_account.admin.email, account: current_account, status: :applied)
    if applicant.save
      redirect_to search_interviews_path, notice: "You have applied to interview - #{@interview.name}!"
    else
      redirect_to search_interviews_path, notice: "Can't apply to interview - #{@interview.name}"
    end
  end

private

  def find_interview
    @interview = Interview.find(params[:interview_id] || params[:id]).decorate
    # TODO: Authorize interview ownership
  end

  def find_interview_by_code
    @interview = Interview.find_by_code(params[:id])
    unless @interview
      return redirect_to dashboard_path, alert: "Interview not found."
    end
  end

  def interview_params
    params.require(:interview).permit(:name, :type, :starts_at, :completed, :read_ahead, :needs_hardware, :read_ahead_file,
      :category_id, :posting, :ideal_guest_desc, :ideal_listener_action, :audio_visual_download_options, :audio_download_formats,
      :max_resolution, :state, topic_list: [], promotion_list: [], expertise_list: [])
  end

  def setup_for_new
    solicited = params[:solicited] == 'true'
    @interview ||= Interview.new(posting: params[:posting], type: solicited ? 'SolicitedInterview' : 'HostInterview')
    @interview.needs_hardware = ActiveModel::Type::Boolean.new.cast(params[:needs_hardware])
    # TODO: authorize solicited interview creation for pro guests and redirect back to interviews page
    #       prevent host interview creation for guests
  end

  def invite_params
    params.require(:invite).permit(:name, :email, :address_line1, :address_line2, :city, :state, :zip_code, :is_last_invite_for_now)
  end

  # this helper method Used in live action
  def host_of?(_interview)
    _interview.user.id == current_user.id
  end

  def ready_invite
    invite = @interview.invites.where(email: current_user.email).first
    invite&.ready!
  end

  private

  def filter_params
    params.require(:filter).permit(topic_list: [], promotion_list: [], expertise_list: []) if params[:filter].present?
  end

end
