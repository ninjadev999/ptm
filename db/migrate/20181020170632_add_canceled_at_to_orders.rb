class AddCanceledAtToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :canceled_at, :datetime
  end
end
