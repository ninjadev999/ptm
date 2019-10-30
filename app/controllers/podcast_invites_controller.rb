class PodcastInvitesController < BaseController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_invitation_by_code, only: [:edit, :confirm, :decline, :destroy, :resend]

  def new
    @account = Account.find params[:account_id]
    @podcast_invite = PodcastInvite.new
    @podcast_invite.account = @account
  end

  def create
    @podcast_invite = PodcastInvite.new(podcast_invite_params.merge!(host_id: current_user.id))

    if @podcast_invite.save
      @podcast_invite.send_invite
      flash[:notice] = "Invitation sent to email #{@podcast_invite.email}."
      redirect_to accounts_path
    else
      flash.now[:alert] = "The following problems prevented the interviewee from being invited: #{@podcast_invite.errors.full_messages.join('; ')}"
      render :new
    end
  end

  def edit
    session[:invite_code] = params[:id]
    render layout: "account"
  end

  def confirm
    # to prevent Matt's fancy testing
    if current_user.email != @podcast_invite.email
      return redirect_to edit_podcast_invite_path(@podcast_invite.code), alert: 'You are logged in as another user. Please sign out before you continue'
    end

    user = User.find_by(email: @podcast_invite.email)
    @podcast_invite.update(user: user) if user.present?
    @podcast_invite.confirm!
    if user
      notice = "You accepted invitation to be an admin of #{@podcast_invite.account.name}."
      notice += ' Please sign in and manage interviews' unless user_signed_in?
      flash[:notice] = notice
      redirect_to select_account_path(@podcast_invite.account)
    else
      flash[:notice] = "You accepted invitation to be an admin of #{@podcast_invite.account.name}. Please complete your profile and manage your interviews."
      redirect_to set_password_host_account_setups_path
    end
  end

  def decline
    @podcast_invite.decline!
    redirect_to params[:redirect_url], notice: "You declined invitation to be an admin of #{@podcast_invite.account.name}."
  end

  def destroy
    if @podcast_invite.destroy
      redirect_to account_path(@podcast_invite.account), notice: "Removed #{@podcast_invite.name} from #{@podcast_invite.account.name}"
    else
      redirect_to account_path(@podcast_invite.account), alert: @podcast_invite.errors.full_messages.join('; ')      
    end
  end

  def resend
    if @podcast_invite.send_invite
      redirect_to edit_account_path(@podcast_invite.account), notice: 'Resent invitation successfully'
    else
      redirect_to edit_account_path(@podcast_invite.account), error: 'Cannot resend invitation'
    end
  end

  private

    def podcast_invite_params
      params.require(:podcast_invite).permit(:account_id, :name, :email, :code, :status, :city, :state, :zipcode)
    end

    def find_invitation_by_code
      @podcast_invite = PodcastInvite.find_by!(code: params[:id])
    end

end

