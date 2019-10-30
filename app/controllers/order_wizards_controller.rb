# frozen_string_literal: true

class OrderWizardsController < BaseController
  layout "order_wizards"
  before_action :ensure_createable_order!, only: [:new, :create]
  before_action :find_order, only: [:edit, :update]

  def new
    @order = Order.new
  end

  def create
    @order = current_account.orders.new(order_params)
    @order.user = current_user
    if @order.save
      redirect_to "/order_wizards/#{@order.id}/edit"
    else
      render :new
    end
  end

  def show
    if params[:id] == "edit"
      return redirect_to "/order_wizards/new"
    end
    redirect_to "/order_wizards/#{params[:id]}/edit"
  end

  def edit
  end

  def update
    if @order.update_attributes(order_params)
      if @order.confirmed?
        return redirect_to "/orders/#{@order.to_param}", notice: "Your order has been placed."
      end
      redirect_to "/order_wizards/#{@order.id}/edit"
    else
      render :edit
    end
  end

  helper_method :determined_step
  def determined_step
    if params[:step].present?
      if params[:step].to_i.between?(1, 5) && params[:step].to_i < max_step
        return params[:step].to_i
      end
    end
    max_step
  end

  def max_step
    return 1 if @order.new_record?
    return 2 if @order.interview_at.nil?
    return 3 unless @order.address.try(:persisted?)
    return 4 unless @order.confirmed?
    5
  end

private

  def ensure_createable_order!
    unless current_account.new_order?
      redirect_to "/orders", notice: current_account.new_order_reason
    end
  end

  def find_order
    @order = current_account.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:name, :company, :interview_at, :finalize, address_attributes: [:nickname, :name, :street1, :street2, :city, :state, :zip, :country])
  end
end
