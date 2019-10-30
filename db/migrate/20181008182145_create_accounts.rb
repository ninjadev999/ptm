class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.integer :admin_id
      t.string :stripe_customer_id
      t.string :name

      t.timestamps
    end
    add_index :accounts, :admin_id
    add_index :accounts, :stripe_customer_id
  end
end
