class AddEmailToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :email, :string
    add_index :orders, :email
  end
end
