class ChangeRoleDefault < ActiveRecord::Migration[5.2]
  def change
  	User.update_all(role: 0)
  	change_column :users, :role, :integer, null: false, default: 0
  end
end
