# frozen_string_literal: true

class AccountsController < BaseController
  before_action :find_account, except: [:index, :new, :create]
  before_action :ensure_account_admin!, only: [:edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:show_public_account]
  skip_before_action :find_account, only: [:show_public_account]

  def index
    redirect_if_no_accounts
    @accounts = AccountDecorator.decorate_collection(current_user.accounts.all)
  end

  def new
    @account = Account.new
    @account.account_social_sites.build
    @account.account_public_sites.build
  end

  def create
    @account = Account.new(account_params)
    @account.admin = current_user
    if @account.save
      redirect_to "/accounts"
    else
      render :new
    end
  end

  def show
    @invites = @account.podcast_invites
  end

  def show_public_account
    @account = Account.where(id: params[:id]).first
  end

  def edit
    @invites = @account.podcast_invites
  end

  def update
    if @account.update_attributes(account_params)
      if account_params[:account_social_sites_attributes].present? || account_params[:account_public_sites_attributes].present?
        redirect_to edit_account_path(@account)
      else 
        redirect_to '/accounts', notice: "Podcast details updated."
      end
    else 
      render :edit  
    end
  end

  def destroy
    if @account.destroy
      redirect_to '/accounts', notice: 'Podcast has been removed.'
    else
      render :edit
    end
  end

  def delete
    desctroy
  end

  # hate this
  def select
    set_current_account(@account.id)
    redirect_path = params[:new_interview] == 'true' ? new_interview_path : interviews_path
    redirect_to redirect_path
  end

private

  def account_params
    params.require(:account).permit(:name, :logo, :remove_logo, :description, :time_zone,
                                    :address_line1, :address_line2, :city, :state, :zip_code, :country,
                                    :max_resolution, :audio_visual_download_options, :audio_download_formats,
                                    :wants_help_finding_interviewees, :downloads_per_episode, :social_media_followers,
                                    account_social_sites_attributes: [:id, :url, :social_site_id, :_destroy],
                                    account_public_sites_attributes: [:id, :url, :public_site_id, :_destroy])
  end

  def find_account
    @account = current_user.accounts.find(params[:id])
  end

end
