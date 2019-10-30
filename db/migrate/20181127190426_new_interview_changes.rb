class NewInterviewChanges < ActiveRecord::Migration[5.2]
  def change
    change_column_default :interviews, :state, -> { -1 }

    add_column :invites, :address_line1, :string
    add_column :invites, :address_line2, :string
    add_column :invites, :city, :string
    add_column :invites, :state, :string
    add_column :invites, :zip_code, :string
  end
end
