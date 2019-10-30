class AddCodeToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :code, :string
    add_index :rooms, :code
  end
end
