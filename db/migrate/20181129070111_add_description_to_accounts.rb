class AddDescriptionToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :description, :text
  end
end
