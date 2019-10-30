class AddUserIdtoInvoiceAndSubscription < ActiveRecord::Migration[5.2]
  def change
  	add_reference :invoices, :user, index: true
  	add_reference :subscriptions, :user, index: true
  end
end
