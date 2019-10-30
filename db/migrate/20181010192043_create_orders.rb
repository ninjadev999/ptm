class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :unit_id
      t.integer :account_id
      t.integer :user_id
      t.integer :interviewee_id
      t.integer :shipping_label_id
      t.integer :return_label_id
      t.integer :address_id
      t.integer :credit_card_id
      t.string :token
      t.date :interview_at

      t.timestamps
    end
    add_index :orders, :unit_id
    add_index :orders, :account_id
    add_index :orders, :user_id
    add_index :orders, :interviewee_id
    add_index :orders, :shipping_label_id
    add_index :orders, :return_label_id
    add_index :orders, :address_id
    add_index :orders, :token
  end
end
