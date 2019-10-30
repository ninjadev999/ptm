class AddOrderIdToLabels < ActiveRecord::Migration[5.2]
  def change
    add_column :labels, :order_id, :integer
    add_index :labels, :order_id
  end
end
