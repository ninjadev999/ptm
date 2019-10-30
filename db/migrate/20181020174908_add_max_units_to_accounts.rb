class AddMaxUnitsToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :max_units, :integer, default: 1, null: false
  end
end
