# frozen_string_literal: true

class OrdersController < BaseController
  skip_before_action :authenticate_user!, only: [:invite]
  before_action :authorize_account!, except: [:invite]
  before_action :find_order, only: [:edit, :show, :update, :destroy]
  before_action :ensure_order_active!, only: [:edit, :update, :destroy]
  before_action :ensure_order_editable!, only: [:edit, :update, :destroy]

  def index
    @orders = current_account.orders.all
  end

  def new
    redirect_to "/order_wizards/new"
  end

  def edit
    redirect_to "/order_wizards/#{@order.to_param}/edit"
  end

  def create
  end

  def show
  end

  def update
  end

  def destroy
    if @order.cancel
      redirect_to "/orders", notice: "Successfully destroyed order."
    else
      redirect_to "/orders", alert: "Couldn't cancel order."
    end
  end

private

  def ensure_order_active!
    if @order.canceled?
      redirect_to "/orders/#{@order.to_param}", notice: "This order has been canceled."
    end
  end

  def ensure_order_editable!
    unless @order.editable?
      redirect_to "/orders/#{@order.to_param}", notice: "The order is not able to be changed at this time."
    end
  end

  def order_params
    params.require(:order).permit(:credit_card_id, :email, :interview_at, :confirm,
                                  address_attributes: [:nickname, :name, :street1, :street2, :city, :state, :zip, :country])
  end

  def find_order
    @order = current_account.orders.find(params[:id])
  end
end
