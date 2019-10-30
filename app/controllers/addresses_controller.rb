# frozen_string_literal: true

class AddressesController < BaseController
  def new
    @addresses = current_user.addresses
  end

  def create
    address = current_user.addresses.new(address_params)
    if address.save
      redirect_to "/orders/new", notice: "Successfully created address."
    else
      redirect_to "/orders/new", alert: "Unable to create address"
    end
  end

private

  def address_params
    params.require(:address).permit(:name, :phone, :street1, :street2, :street3, :city, :state, :zip, :country, :nickname)
  end
end
