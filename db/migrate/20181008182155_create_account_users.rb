class CreateAccountUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :account_users do |t|
      t.integer :account_id
      t.integer :user_id

      t.timestamps
    end
    add_index :account_users, [:account_id, :user_id]
  end
end
