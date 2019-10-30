class AddHiddenToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :interviewer, :boolean, default: false
  end
end
