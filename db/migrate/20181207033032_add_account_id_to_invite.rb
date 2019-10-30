class AddAccountIdToInvite < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :account_id, :integer
  end
end
