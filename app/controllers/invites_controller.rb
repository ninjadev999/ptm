# frozen_string_literal: true

class InvitesController < BaseController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :find_invite, only: [:destroy, :resend]
  before_action :find_invite_by_code, only: [:edit, :update, :confirm, :decline]
  before_action :find_interview, only: [:new, :create]

  # Step 2 of the New Interview flow
  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.new(invite_params)

    if @invite.left_blank?
      if @interview.incomplete?
        return redirect_to_next_step
      else
        flash[:notice] = "No interviewees have been invited." unless @interview.invites.exists?
        return redirect_to interview_path(@interview)
      end
    end

    @invite.interview = @interview

    if @invite.save
      flash[:notice] = "Invitation added for #{@invite.name}."

      add_another = ActiveModel::Type::Boolean.new.cast(params[:add_another])
      if @interview.incomplete? && !add_another
        redirect_to_next_step
      elsif add_another
        redirect_to new_invite_path(interview_id: @interview)
      else
        redirect_to interview_path(@interview)
      end
    else
      flash.now[:alert] = "The following problems prevented the interviewee from being invited: #{@invite.errors.full_messages.join('; ')}"
      render :new
    end
  end

  def resend
    if @invite.send_invite
      redirect_to interview_path(@invite.interview), notice: 'Resent invitation successfully'
    else
      redirect_to interview_path(@invite.interview), error: 'Cannot resend invitation'
    end
  end

  def destroy
    @interview = @invite.interview
    @invite.destroy
    redirect_to interview_path(@interview), notice: "Invite removed."
  end

   # -------------------------------------
   #  METHODS for UNAUTHENTICATED INVITEES
   # -------------------------------------

   def edit
    @interview = @invite.interview
    return interview_cancelled if @interview.nil?

    session[:invite_code] = params[:id]
    render layout: "account"
   end

   def update
    return interview_cancelled if @invite.interview.nil?
    if @invite.update_attributes(invite_params)
      redirect_to edit_invite_path(@invite.code), notice: "Your information has been successfully updated."
    else
      flash.now[:alert] = "The following errors prevented your info from being saved: #{@invite.errors.full_messages.join('; ')}"
      render :edit
    end
   end

   def confirm
    return interview_cancelled if @invite.interview.nil?
    @invite.confirm!
    
    flash[:notice] = "Your interview appearance has been confirmed."
    if user_signed_in?
      redirect_to interview_path(@invite.interview)
    else
      redirect_to edit_invite_path(@invite.code)
    end
   end

   def decline
    return interview_cancelled if @invite.interview.nil?
    @invite.decline!
    redirect_to params[:redirect_url], notice: "Your interview appearance has been declined."
   end

private

  def find_invite
    @invite = Invite.find(params[:id])
    # TODO: add authorization for current_user here
  end

  def find_invite_by_code
    @invite = Invite.find_by!(code: params[:id])
  end

  def find_interview
    @interview = current_user.host_interviews.find(params[:interview_id])
  end

  def invite_params
    params.require(:invite).permit(:name, :email, :address_line1, :address_line2, :city, :state, :zip_code, :is_last_invite_for_now)
  end

  def redirect_to_next_step
    if @interview.free? || @interview.account.admin.single_itv_available?
      @interview.payment_complete!
      redirect_to interview_path(@interview), notice: "Your interview has been created."
    else
      redirect_to checkout_path(id: @interview.id)
    end
  end

  def interview_cancelled
    redirect_to root_path, alert: "This interview has been cancelled. Please contact the host of '#{@invite.interview.user.full_name}' for more details."
  end

end