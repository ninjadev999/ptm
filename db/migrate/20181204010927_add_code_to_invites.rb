class AddCodeToInvites < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :code, :string
  end
end
