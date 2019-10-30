# frozen_string_literal: true

module CurrentAccount
  class InvoicesController < BaseController
    def index
      @invoices = current_account.invoices.all
    end

    def update
      @invoice = current_account.invoices.find_by_number(params[:id])
      if @invoice.pay
        redirect_to "/account/invoices", notice: "Successfully paid invoice."
      else
        redirect_to "/account/invoices", alert: @invoice.errors.full_messages.first
      end
    end
  end
end
