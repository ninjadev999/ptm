class AddTimeZoneLocationToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :time_zone, :string
    add_column :accounts, :address_line1, :string
    add_column :accounts, :address_line2, :string
    add_column :accounts, :city, :string
    add_column :accounts, :state, :string
    add_column :accounts, :zip_code, :string
    add_column :accounts, :country, :string
    add_column :accounts, :wants_help_finding_interviewees, :boolean, default: false
  end
end
