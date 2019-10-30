class AddStateToInvites < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :status, :integer, default: 10
  end
end
