class AddPositionToPlan < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :position, :integer, null: false, default: 0
  end
end
