class AddGuestHostToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :guest, :boolean, default: false, null: false
    add_column :users, :host, :boolean, default: true, null: false
    remove_column :users, :role, :integer
  end
end
