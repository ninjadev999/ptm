class RemoveUnusedfields < ActiveRecord::Migration[5.2]
  def change
  	remove_column :interviews, :user_id
  	remove_column :invites, :inviter_account_id
  end
end
