class AddGuestIdToInvite < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :guest_id, :integer
  end
end
