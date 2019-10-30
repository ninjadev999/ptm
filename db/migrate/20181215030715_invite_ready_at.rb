class InviteReadyAt < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :ready_at, :datetime
  end
end
