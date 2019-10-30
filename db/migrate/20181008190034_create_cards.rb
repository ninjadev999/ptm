class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :credit_cards do |t|
      t.integer :account_id
      t.string :last_4
      t.string :kind
      t.integer :exp_mo
      t.integer :exp_year
      t.string :stripe_card_id

      t.timestamps
    end
    add_index :credit_cards, :account_id
    add_index :credit_cards, :stripe_card_id
  end
end
